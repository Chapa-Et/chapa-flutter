class ValidateDirectChargeResponse {
  String? message;
  String? trxRef;
  String? processorId;

  ValidateDirectChargeResponse({
    this.message,
    this.trxRef,
    this.processorId,
  });

  ValidateDirectChargeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trxRef = json['trx_ref'];
    processorId = json['processor_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['message'] = message;
    data['trx_ref'] = trxRef;
    data['processor_id'] = processorId;
    return data;
  }
}
