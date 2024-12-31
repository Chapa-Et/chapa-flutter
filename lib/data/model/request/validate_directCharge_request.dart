// ignore: file_names
class ValidateDirectChargeRequest {
  final String reference;
  final String mobile;
  final String paymentMethod;
  ValidateDirectChargeRequest({
    required this.reference,
    required this.mobile,
    required this.paymentMethod,
  });
  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "mobile": mobile,
      "payment_method": paymentMethod
    };
  }
}
