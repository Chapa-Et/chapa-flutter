/// Represents the response for validating a direct charge request.
class ValidateDirectChargeResponse {
  /// Message accompanying the validation response.
  String? message;

  /// Transaction reference associated with the direct charge.
  String? trxRef;

  /// Processor ID of the direct charge transaction.
  String? processorId;

  /// Historical data related to the direct charge transaction.
  HistoryData? data;

  /// Creates an instance of [ValidateDirectChargeResponse].
  ValidateDirectChargeResponse({
    this.message,
    this.trxRef,
    this.processorId,
    required this.data,
  });

  /// Initializes a [ValidateDirectChargeResponse] instance from a JSON map.
  ValidateDirectChargeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trxRef = json['trx_ref'];
    processorId = json['processor_id'];
    data = HistoryData.fromJson(json['data']);
  }

  /// Retrieves the `createdAt` timestamp as a [DateTime] object.
  ///
  /// - If the [data] object or its `createdAt` field is `null`, the current time
  ///   is returned.
  /// - Otherwise, parses the `createdAt` field into a [DateTime].
  DateTime getCreatedAtTime() {
    if (data != null) {
      if (data?.createdAt != null) {
        return DateTime.parse(data!.createdAt!);
      } else {
        return DateTime.now();
      }
    } else {
      return DateTime.now();
    }
  }
}

/// Represents historical data for a direct charge transaction.
class HistoryData {
  /// Amount involved in the transaction.
  String? amount;

  /// Charge applied to the transaction.
  String? charge;

  /// Status of the transaction (e.g., "success", "failed").
  String? status;

  /// Timestamp when the transaction was created.
  String? createdAt;

  /// Creates an instance of [HistoryData].
  HistoryData({
    this.amount,
    this.charge,
    this.status,
    this.createdAt,
  });

  /// Initializes a [HistoryData] instance from a JSON map.
  HistoryData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    charge = json['charge'];
    status = json['status'];
    createdAt = json['created_at'];
  }
}
