import 'dart:convert';

ResponseData dataFromJson(String str) =>
    ResponseData.fromJson(json.decode(str));

String dataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
  ResponseData({
    required this.message,
    required this.status,
    required this.data,
  });

  String message;
  String status;
  DataClass data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
        message: json["message"],
        status: json["status"],
        data: DataClass.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "data": data.toJson(),
      };
}

class DataClass {
  DataClass({
    required this.checkoutUrl,
  });

  String checkoutUrl;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
        checkoutUrl: json["checkout_url"],
      );

  Map<String, dynamic> toJson() => {
        "checkout_url": checkoutUrl,
      };
}
