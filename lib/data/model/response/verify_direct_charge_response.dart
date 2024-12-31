class ValidateDirectChargeResponse {
  String? message;
  String? trxRef;
  String? processorId;
  HistoryData? data;
  ValidateDirectChargeResponse(
      {this.message, this.trxRef, this.processorId, required this.data});

  ValidateDirectChargeResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trxRef = json['trx_ref'];
    processorId = json['processor_id'];
    data = HistoryData.fromJson(json['data']);
  }

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

class HistoryData {
  String? amount;
  String? charge;
  String? status;
  String? createdAt;

  HistoryData({this.amount, this.charge, this.status, this.createdAt});

  HistoryData.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    charge = json['charge'];
    status = json['status'];
    createdAt = json['created_at'];
  }
  
}
