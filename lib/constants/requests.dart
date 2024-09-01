import 'dart:convert';
import 'package:chapasdk/constants/common.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../chapawebview.dart';
import '../model/data.dart';

Future<String> intilizeMyPayment(
    BuildContext context,
    String authorization,
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
    List<Map<String, dynamic>>? subaccounts) async {
  Map<String, String> body = {
    'phone_number': phone,
    'amount': amount,
    'currency': currency.toUpperCase(),
    'first_name': firstName,
    'last_name': lastName,
    'tx_ref': transactionReference,
    'customization[title]': customTitle,
    'customization[description]': customDescription,
  };

  if (subaccounts != null && subaccounts.isNotEmpty) {
    body['subaccounts'] = jsonEncode(subaccounts);
  }

  final http.Response response = await http.post(
    Uri.parse(ChapaUrl.baseUrl),
    headers: {
      'Authorization': 'Bearer $authorization',
    },
    body: body,
  );
  var jsonResponse = json.decode(response.body);
  if (response.statusCode == 400) {
    showToast(jsonResponse);
  } else if (response.statusCode == 200) {
    ResponseData res = ResponseData.fromJson(jsonResponse);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ChapaWebView(
                url: res.data.checkoutUrl.toString(),
                fallBackNamedUrl: fallBackNamedRoute,
                transactionReference: transactionReference,
                amountPaid: amount,
              )),
    );

    return res.data.checkoutUrl.toString();
  }

  return '';
}

Future<Map<String, dynamic>> initiateBulkTransfer(
  String authorization,
  String title,
  String currency,
  List<Map<String, dynamic>> bulkData,
) async {
  final response = await http.post(
    Uri.parse('${ChapaUrl.baseUrl}/bulk-transfers'),
    headers: {
      'Authorization': 'Bearer $authorization',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'currency': currency,
      'bulk_data': bulkData,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    showErrorToast('Bulk transfer failed. Please try again.');
    return {};
  }
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
