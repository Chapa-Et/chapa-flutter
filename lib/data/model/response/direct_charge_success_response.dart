import 'package:chapasdk/domain/constants/enums.dart';
import 'package:chapasdk/domain/constants/extentions.dart';

/// Represents the response for a successful direct charge request.
class DirectChargeSuccessResponse {
  /// Message accompanying the success response.
  String? message;

  /// Status of the response.
  String? status;

  /// Data object containing additional information about the response.
  Data? data;

  /// Creates a [DirectChargeSuccessResponse] instance.
  DirectChargeSuccessResponse({this.message, this.status, this.data});

  /// Initializes a [DirectChargeSuccessResponse] instance from a JSON map.
  DirectChargeSuccessResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = Data.fromJson(json['data']);
  }
}

/// Contains detailed data about a direct charge success response.
class Data {
  /// Type of verification/authentication required.
  VerificationType? authDataType;

  /// Request ID associated with the transaction.
  String? requestID;

  /// Metadata containing additional information about the transaction.
  MetaData? meta;

  /// Mode of the transaction.
  String? mode;

  /// Creates a [Data] instance.
  Data({this.authDataType, this.requestID, this.meta, this.mode});

  /// Initializes a [Data] instance from a JSON map.
  Data.fromJson(Map<String, dynamic> json) {
    authDataType = json["auth_type"].toString().parseAuthDataType();
    requestID = json['requestID'];
    meta = MetaData.fromJson(json['meta']);
    mode = json['mode'];
  }
}

/// Represents metadata information for a direct charge transaction.
class MetaData {
  /// Message accompanying the metadata.
  String? message;

  /// Status of the metadata.
  String? status;

  /// Reference ID for the payment.
  String? refId;

  /// Status of the payment.
  PaymentStatus? paymentStatus;

  /// Creates a [MetaData] instance.
  MetaData({this.message, this.status, this.paymentStatus, this.refId});

  /// Initializes a [MetaData] instance from a JSON map.
  MetaData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    refId = json['ref_id'];
    paymentStatus = json['payment_status'].toString().parsePaymentStatus();
  }
}
