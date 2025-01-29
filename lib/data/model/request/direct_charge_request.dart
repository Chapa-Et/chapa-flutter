/// A model class representing the details of a direct charge request.
///
/// This is used to structure the data required for initiating a direct charge
/// transaction via the payment gateway.
class DirectChargeRequest {
  /// The first name of the customer.
  final String firstName;

  /// The last name of the customer.
  final String lastName;

  /// The mobile phone number of the customer.
  final String mobile;

  /// The transaction reference ID.
  final String txRef;

  /// The amount to be charged.
  final String amount;

  /// The currency of the payment (defaults to "ETB" if not "ETB").
  final String currency;

  /// The email address of the customer.
  final String email;

  /// The payment method to be used.
  final String paymentMethod;

  /// Constructor for the [DirectChargeRequest] class.
  ///
  /// All fields are required.
  DirectChargeRequest({
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.amount,
    required this.currency,
    required this.email,
    required this.txRef,
    required this.paymentMethod,
  });

  /// Converts the [DirectChargeRequest] instance to a JSON-compatible map.
  ///
  /// If the [currency] is not "ETB", it defaults to "ETB".
  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      "currency": currency == "ETB" ? currency : "ETB",
      "tx_ref": txRef,
      "amount": amount,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "payment_method": paymentMethod,
    };
  }
}
