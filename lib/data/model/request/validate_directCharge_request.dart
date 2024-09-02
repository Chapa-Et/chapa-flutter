// ignore: file_names
class ValidateDirectChargeRequest {
  final String client;
  final String referenceId;
  ValidateDirectChargeRequest({required this.client, required this.referenceId});
  toJson() {
    return {
      "reference": referenceId,
      "client": client,
    };
  }
}
