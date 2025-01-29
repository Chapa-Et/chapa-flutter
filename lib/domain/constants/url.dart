/// A class that contains the URLs used for API requests in the Chapa payment system.
/// These URLs are used for different payment operations such as initiating a payment and verifying transactions.
class ChapaUrl {
  /// The URL endpoint for initiating a payment (generate a checkout link for web based payment) using web checkout.
  static const String chapaPay = "https://api.chapa.co/v1/hosted/pay";

  /// The base URL for the direct charge operations.
  static String directChargeBaseUrl = "https://inline.chapaservices.net/v1";

  /// The endpoint for initiating a direct charge transaction.
  /// This URL is used to initiate a charge for inline payments.
  static String directCharge = "/inline/charge";

  /// The endpoint for verifying a direct charge transaction.
  /// This URL is used to validate a charge after it has been initiated.
  static String verifyUrl = "/inline/validate";
}
