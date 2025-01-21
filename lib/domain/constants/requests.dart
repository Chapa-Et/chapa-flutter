import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chapasdk/chapawebview.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/domain/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

Future<String> initializeMyPayment(
  BuildContext context,
  String email,
  String phone,
  String amount,
  String currency,
  String firstName,
  String lastName,
  String transactionReference,
  String customTitle,
  String customDescription,
  String fallBackNamedRoute,
  String publicKey,
  Function(String, String, String)? onPaymentFinished,
) async {
  try {
    final http.Response response = await http.post(
      Uri.parse(ChapaUrl.chapaPay),
      body: {
        'public_key': publicKey,
        'phone_number': phone,
        'amount': amount,
        'currency': currency.toUpperCase(),
        'first_name': firstName,
        'last_name': lastName,
        "email": email,
        'tx_ref': transactionReference,
        'customization[title]': customTitle,
        'customization[description]': customDescription
      },
    );
    if (response.statusCode == 400) {
      var jsonResponse = json.decode(response.body);
      showToast(jsonResponse);
      return '';
    } else if (response.statusCode == 302) {
      String? redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChapaWebView(
                    url: redirectUrl,
                    fallBackNamedUrl: fallBackNamedRoute,
                    transactionReference: transactionReference,
                    amountPaid: amount,
                  )),
        );
      }
      return redirectUrl.toString();
    } else {
      try {
        ApiErrorResponse apiErrorResponse = ApiErrorResponse.fromJson(
            json.decode(response.body), response.statusCode);
        showToast({
          'message': apiErrorResponse.message ??
              "Something went wrong. Please Contact Us.",
        });
        log(response.body);
        return '';
      } catch (e) {
        return '';
      }
    }
  } on SocketException catch (_) {
    showToast({
      'message':
          "There is no Internet Connection \n Please check your Internet Connection and Try it again."
    });
    return '';
  } catch (e) {
    log(e.toString());
    log("Exception here");
    return '';
  }
}

Future<bool?> showToast(jsonResponse) {
  return Fluttertoast.showToast(
      msg: jsonResponse['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
