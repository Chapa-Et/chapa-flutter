class DirectChargeApiError {
  String? message;
  String? status;
  ValidationErrorData? data;
  int? code;
  Validate? validate;
  String? paymentStatus;

  DirectChargeApiError(
      {required this.message,
      required this.status,
      this.data,
      required this.code,
      this.validate,
      this.paymentStatus});

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

class Validate {
  List<String>? mobile;
  String? status;
  String? data;

  Validate({
    this.mobile,
    this.status,
    this.data,
  });

  Validate.fromJson(
    Map<String, dynamic> json,
  ) {
    mobile = json['mobile'];
  }
}

class ValidationErrorData {
  String? message;
  String? status;
  dynamic data;
  String? paymentStatus;

  ValidationErrorData(
      {required this.message,
      required this.status,
      this.data,
      this.paymentStatus});

  ValidationErrorData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
    paymentStatus = json['payment_status'];
  }
}
