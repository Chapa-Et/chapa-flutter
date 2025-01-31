import 'dart:convert';
import 'package:http/http.dart';

/// Represents a structured response from an API request, including status code,
/// message, body, and error information.
class ApiResponse {
  /// HTTP status code of the API response.
  int? code;

  ///  Message for the API response.
  String? message;

  /// Dynamic body content of the API response.
  dynamic body;

  /// List of errors returned by the API, if any.
  List? errors;

  /// Creates an instance of [ApiResponse].
  ///
  /// The [code] and [message] parameters are required, while [body] and [errors]
  /// are optional.
  ApiResponse({
    required this.code,
    required this.message,
    this.body,
    this.errors,
  });

  /// Factory method to create an [ApiResponse] from an HTTP response object.
  factory ApiResponse.fromResponse(Response response) {
    int code = response.statusCode;
    dynamic body = jsonDecode(response.body);
    List errors = [];
    String message = "";

    switch (code) {
      case 200:
      case 201:
        try {
          message = body is Map ? body['message'] ?? "" : "";
        } catch (error) {
          // Handle any error in reading message
          message = "";
        }
        break;
      case 400:
        try {
          message = body is Map ? body['errors'][0]['message'] ?? "" : "";
          errors.add(message);
        } catch (error) {
          message = body is Map ? body['message'] ?? "" : "";
          errors.add(message);
        }
        break;
      case 401:
        try {
          message =
              body is Map ? body['message'] ?? "Unauthorized" : "Unauthorized";
          errors.add(message);
        } catch (error) {
          errors.add("Unauthorized");
        }
        break;
      case 408:
        message = "Server timeout, please try again later.";
        errors.add(message);
        break;
      case 429:
        try {
          message = body is Map
              ? body['message'] ?? "Too many requests"
              : "Too many requests";
          errors.add(message);
        } catch (error) {
          errors.add("Too many requests");
        }
        break;
      default:
        message = body is Map
            ? body["message"] ?? "Something went wrong."
            : "Something went wrong.";
        break;
    }

    return ApiResponse(
      code: code,
      message: message,
      body: body,
      errors: errors,
    );
  }

  /// Getter for accessing the `data` part of the response body.
  List get data => body["body"];

  /// Checks if there are any errors in the API response.
  bool hasError() => errors!.isNotEmpty;

  /// Checks if there are any message errors in the API response.
  bool hasMessageError() => message!.isNotEmpty;

  /// Checks if the API response contains any data.
  bool hasData() => data.isNotEmpty;

  /// Checks if the API response indicates that everything is good.
  bool get allGood => errors!.isEmpty;

  /// Retrieves the exception message from the API response.
  String get hasException => exception!;

  /// Exception message placeholder, currently not in use.
  String? exception;

  /// Initializes an [ApiResponse] instance from a JSON map.
  ApiResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
