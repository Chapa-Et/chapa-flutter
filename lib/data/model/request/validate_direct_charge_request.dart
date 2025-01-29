/// A class representing a request to validate a direct charge.
///
/// This class encapsulates the required fields for validating a direct charge request,
/// including the reference, mobile number, and payment method.
///
/// - [reference]: The unique reference identifier for the payment.
/// - [mobile]: The mobile number associated with the payment.
/// - [paymentMethod]: The method used for the payment.
class ValidateDirectChargeRequest {
  /// The unique reference identifier for the payment.
  final String reference;

  /// The mobile number associated with the payment.
  final String mobile;

  /// The method used for the payment.
  final String paymentMethod;

  /// Constructor for the [ValidateDirectChargeRequest] class.
  ///
  /// Requires the [reference], [mobile], and [paymentMethod] fields to be provided.
  ValidateDirectChargeRequest({
    required this.reference,
    required this.mobile,
    required this.paymentMethod,
  });

  /// Converts the [ValidateDirectChargeRequest] instance to a JSON object.
  ///
  /// This method is useful for sending the request as JSON to an API endpoint.
  Map<String, dynamic> toJson() {
    return {
      "reference": reference,
      "mobile": mobile,
      "payment_method": paymentMethod
    };
  }
}
