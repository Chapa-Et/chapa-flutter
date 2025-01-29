/// A model class to represent API error responses.
class ApiErrorResponse {
  /// The error message or concatenated error messages if multiple errors exist.
  String? message;

  /// The HTTP status code returned by the API.
  int? statusCode;

  /// The status string indicating the API request result.
  String? status;

  /// Additional data returned in the API response, if any.
  String? data;

  /// Validation-specific information returned in the API response, if any.
  String? validation;

  /// Constructor to initialize the API error response object.
  ///
  /// [message] represents the error message(s) returned by the API.
  /// [statusCode] represents the HTTP status code.
  ApiErrorResponse({
    this.message,
    this.statusCode,
    this.status,
    this.data,
    this.validation,
  });

  /// Factory constructor to parse JSON data and create an [ApiErrorResponse] object.
  ///
  /// [json] is the API response body as a [Map<String, dynamic>].
  /// [statusCode] is the HTTP status code for the response.
  ApiErrorResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    String parsedMessage = "";

    // Check if the 'message' field is a Map and handle dynamic error messages.

    if (json['message'] is Map<String, dynamic>) {
      try {
        json['message'].forEach((key, value) {
          parsedMessage += "${List<String>.from(value).first} ";
        });
      } catch (e) {
        parsedMessage = json['message'].toString();
      }
    } else {
      parsedMessage = json['message'] ?? "";
    }

    message = parsedMessage.trim();
    statusCode = statusCode;
    status = json['status'] ?? "";
    data = json['data'] ?? "";
    validation = json['validate'] ?? "";
  }
}
