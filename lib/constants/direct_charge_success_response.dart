import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/constants/extentions.dart';

class DirectChargeSuccessResponse {
  String? message;
  String? status;
  Data? data;
  DirectChargeSuccessResponse({this.message, this.status, this.data});
  DirectChargeSuccessResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

class Data {
  VerificationType? authDataType;
  String? requestID;
  MetaData? meta;

  Data({
    this.authDataType,
    this.requestID,
    this.meta,
  });

  Data.fromJson(Map<String, dynamic> json) {
    authDataType = json["auth_type"].toString().parseAuthDataType();
    requestID = json['requestID'];
    meta = MetaData.fromJson(json['meta']);
  }
}

class MetaData {
  String? message;
  String? status;
  String? data;
  PaymentStatus? paymentStatus;
  MetaData({this.message, this.status, this.data, this.paymentStatus});

  MetaData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'];
    paymentStatus = json['payment_status'].toString().parsePaymentStatus();
  }
}
