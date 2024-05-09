class ApiErrorResponse {
  String? message;
  int? statusCode;

  ApiErrorResponse({
    this.message,
    this.statusCode,
  });
  ApiErrorResponse.fromJson(Map<String, dynamic> json, int statusCode) {
    message = json['message'];
    statusCode = statusCode;
  }
}
