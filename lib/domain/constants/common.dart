import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Displays an error toast with a given [message].
///
/// Returns a [Future<bool?>] indicating whether the toast was successfully shown.
Future<bool?> showErrorToast(String message) {
  return Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

/// Introduces a delay of 1 second.
///
/// This utility can be used in asynchronous workflows where a slight delay is needed.
Future<void> delay() async {
  await Future.delayed(const Duration(seconds: 1));
}
