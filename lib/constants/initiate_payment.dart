class DirectChargeApiError {
  String? message;
  String? status;
  dynamic data;
  int? code;
  Validate? validate;

  DirectChargeApiError(
      {required this.message,
      required this.status,
      this.data,
      required this.code,
      this.validate});

  DirectChargeApiError.fromJson(Map<String, dynamic> json, int statusCode) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
    code = statusCode;
    validate = json['validate'];
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
