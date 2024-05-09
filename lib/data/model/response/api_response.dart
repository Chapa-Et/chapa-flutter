import 'dart:convert';
import 'package:http/http.dart';

class ApiResponse {
  List get data => body["body"];
  bool get allGood => errors!.isEmpty;
  String get hasException => exception!;
  bool hasError() => errors!.isNotEmpty;
  bool hasMessageError() => messageError!.isNotEmpty;
  bool hasData() => data.isNotEmpty;

  int? code;
  String? message;
  dynamic body;
  List? errors;
  List? messageError;
  String? exception;

  ApiResponse({
    required this.code,
    required this.message,
    this.body,
    this.errors,
  });

  factory ApiResponse.fromResponse(
    Response response,
  ) {
    int code = response.statusCode;
    dynamic body = jsonDecode(response.body);
    List errors = [];
    String message = "";
    List messageError = [];

    switch (code) {
      case 200:
        try {
          message = body is Map ? body['message'] : "";
        } catch (error) {
          messageError.add(message);
        }

        break;
      case 201:
        try {
          message = body is Map ? body['message'] : "";
        } catch (error) {
          messageError.add(message);
        }
        break;
      case 400:
        try {
          message = body is Map ? body['errors'][0]['message'] ?? "" : "";

          errors.add(message);
        } catch (error) {
          message = body is Map ? body['message'] : "";

          errors.add(message);
        }
        break;

      case 401:
        try {
          message =
              body is Map ? body['message'] ?? "unauthorized" : "unauthorized";
          errors.add(message);
        } catch (error) {
          // debugPrint("Message reading error in Error ==> $error");
          errors.add(message);
        }
        break;
      case 408:
        try {
          message =
              "Looks like the server is taking to long to respond, please try again in sometime";
          errors.add(message);
        } catch (error) {
          errors.add(message);
        }
        break;

      case 429:
        try {
          message = body is Map ? body['message'] ?? "" : "too many request";
          errors.add(message);
        } catch (error) {
          errors.add(message);
        }
        break;

      default:
        try {
          message = body["message"] ??
              "Sorry! Something went wrong, please contact support.";
        } catch (e) {
          message = "Sorry! Something went wrong, please contact support.";
        }

        break;
    }

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }

  ApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
