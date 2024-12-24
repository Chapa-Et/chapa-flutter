import 'dart:convert';
import 'dart:developer';
import 'package:chapasdk/domain/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../chapawebview.dart';

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
    String publicKey) async {
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

  try {
    if (response.statusCode == 400) {
      var jsonResponse = json.decode(response.body);
      showToast(jsonResponse);
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
      log("Http Error");
      log(response.body);
    }
  } catch (e) {
    log(e.toString());
    log("Exception here");
  }

  return '';
}

Future<bool?> showToast(jsonResponse) {
  return Fluttertoast.showToast(
      msg: jsonResponse['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}
