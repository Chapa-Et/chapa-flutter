class DirectChargeRequest {
  String firstName;
  String amount;
  String lastName;
  String currency;
  String email;
  String txRef;
  String mobile;
  String paymentMethod;
  DirectChargeRequest({
    required this.mobile,
    required this.firstName,
    required this.lastName,
    required this.amount,
    required this.currency,
    required this.email,
    required this.txRef,
    required this.paymentMethod
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      'currency': currency,
      'tx_ref': txRef,
      'amount': amount,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'payment_method':paymentMethod
    };
  }
}
