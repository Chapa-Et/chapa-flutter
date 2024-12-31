import 'package:chapasdk/domain/constants/enums.dart';
import 'package:chapasdk/domain/constants/extentions.dart';

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
  String? mode;

  Data({this.authDataType, this.requestID, this.meta, this.mode});

  Data.fromJson(Map<String, dynamic> json) {
    authDataType = json["auth_type"].toString().parseAuthDataType();
    requestID = json['requestID'];
    meta = MetaData.fromJson(json['meta']);
    mode = json['mode'];
  }
}

class MetaData {
  String? message;
  String? status;
  String? refId;
  PaymentStatus? paymentStatus;
  MetaData({this.message, this.status, this.paymentStatus, this.refId});

  MetaData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    refId = json['ref_id'];
    paymentStatus = json['payment_status'].toString().parsePaymentStatus();
  }
}
