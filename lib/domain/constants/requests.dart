// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chapasdk/chapawebview.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/domain/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

/// Initializes a payment using the Chapa API.
///
/// This function sends a payment initialization request to the Chapa API, processes the
/// response, and redirects the user to the Chapa payment page if successful.
///

/// Returns a `String` with the redirect URL, or an empty string if the payment initialization fails.
Future<String> initializeMyPayment(
  /// [context] - The current `BuildContext` for navigation.
  BuildContext context,

  /// [customers] - The user's email address.
  String email,

  /// [phone] - The customers's phone number.
  String phone,

  /// [amount] - The amount to be paid.
  String amount,

  /// [currency] - The currency code (e.g., "ETB").

  String currency,

  /// [firstName] - The user's first name.
  String firstName,

  /// [lastName] - The customers's last name.
  String lastName,

  /// [transactionReference] - A unique reference for the transaction.

  String transactionReference,

  /// [customTitle] - Custom title for the payment.
  String customTitle,

  /// [customDescription] - Custom description for the payment.
  String customDescription,

  /// [fallBackNamedRoute] - Named route to navigate to if the payment is canceled or fails.

  String fallBackNamedRoute,

  /// [publicKey] - The public key for authentication for Merchant with the Chapa API.

  String publicKey,

  /// [onPaymentFinished] - Optional callback to execute when the payment is completed.
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
      ApiErrorResponse apiErrorResponse = ApiErrorResponse.fromJson(
          json.decode(response.body), response.statusCode);
      showToast({
        'message': apiErrorResponse.message ??
            "Something went wrong. Please Contact Us.",
      });

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
                    onPaymentFinished: onPaymentFinished,
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

/// Displays a toast notification with the given message.
///
/// [message] - The message to display in the toast.
///
/// Returns a `Future<bool?>` that indicates whether the toast was successfully displayed.

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
