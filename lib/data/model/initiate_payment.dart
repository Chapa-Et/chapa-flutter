/// Represents an error response from the Direct Charge API Error Response.
///
/// This class contains details about the error message, status, code,
/// validation errors, and payment status returned by the API.
class DirectChargeApiError {
  /// The error message describing the issue.
  String? message;

  /// The status of the error, typically a string.
  String? status;

  /// Validation error details.
  ValidationErrorData? data;

  /// The HTTP status code returned by the API.
  int? code;

  /// Additional validation details.
  Validate? validate;

  /// The payment status.
  String? paymentStatus;

  /// Constructs a `DirectChargeApiError` with the required and optional fields.
  DirectChargeApiError({
    required this.message,
    required this.status,
    this.data,
    required this.code,
    this.validate,
    this.paymentStatus,
  });

  /// Creates a `DirectChargeApiError` instance from a JSON object.
  ///
  /// - [json]: The JSON map representing the error response.
  /// - [statusCode]: The HTTP status code for the response.
  DirectChargeApiError.fromJson(Map<String, dynamic> json, int statusCode) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? ValidationErrorData.fromJson(json['data'])
        : null;
    code = statusCode;
    validate = json['validate'];
    paymentStatus = json['payment_status'];
  }
}

/// Represents validation error details from the API.
///
/// This class includes information about validation errors such as
/// invalid mobile numbers or other constraints.
class Validate {
  /// A list of validation errors related to mobile numbers.
  List<String>? mobile;

  /// The status of the validation.
  String? status;

  /// Additional data related to the validation error.
  String? data;

  /// Constructs a `Validate` instance with the given fields.
  Validate({
    this.mobile,
    this.status,
    this.data,
  });

  /// Creates a `Validate` instance from a JSON object.
  ///
  /// - [json]: The JSON map representing validation error details.
  Validate.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
  }
}

/// Represents detailed validation error data.
///
/// This class contains information about the error message, status,
/// associated data, and the payment status.
class ValidationErrorData {
  /// The error message describing the validation issue.
  String? message;

  /// The status of the validation error.
  String? status;

  /// Additional data associated with the validation error.
  dynamic data;

  /// The payment status linked to the validation error, if applicable.
  String? paymentStatus;

  /// Constructs a `ValidationErrorData` instance with the given fields.
  ValidationErrorData({
    required this.message,
    required this.status,
    this.data,
    this.paymentStatus,
  });

  /// Creates a `ValidationErrorData` instance from a JSON object.
  ///
  /// - [json]: The JSON map representing validation error details.
  ValidationErrorData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
    paymentStatus = json['payment_status'];
  }
}
