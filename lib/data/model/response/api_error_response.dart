class ApiErrorResponse {
  String? message;
  int? statusCode;
  String? status;
  String? data;
  String? validation;

  ApiErrorResponse({
    this.message,
    this.statusCode,
  });
  ApiErrorResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    message = json['message'] ?? "";
    statusCode = statusCode;
    status = json['status'] ?? "";
    data = json['data'] ?? "";
    validation = json["validate"] ?? "";
  }
}
