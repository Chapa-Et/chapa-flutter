/// Enum representing various local payment methods available in the application.
enum LocalPaymentMethods {
  /// Represents the Telebirr payment method.
  telebirr,

  /// Represents the M-Pesa payment method.
  mpessa,

  /// Represents the CBE Birr payment method.
  cbebirr,

  /// Represents the E-Birr payment method.
  ebirr,
}

/// Enum defining the types of HTTP request methods used in API interactions.
enum RequestType {
  /// Represents an HTTP GET request.
  get,

  /// Represents an HTTP POST request.
  post,

  /// Represents an HTTP PATCH request.
  patch,

  /// Represents an HTTP PUT request.
  put,

  /// Represents an HTTP DELETE request.
  delete,
}

/// Enum representing the status of a payment transaction.
enum PaymentStatus {
  /// Indicates the payment is still pending.
  pending,

  /// Indicates the payment was successful.
  success,
}

/// Enum defining the modes in which the Merchant Status can operate.
enum Mode {
  /// Represents the live mode of the Merchant.
  live,

  /// Represents the testing mode of the Merchant.
  testing,
}

/// Enum representing the types of verification methods for payment methods.
enum VerificationType {
  /// Represents USSD-based verification.
  ussd,

  /// Represents OTP-based verification.
  otp,
}
