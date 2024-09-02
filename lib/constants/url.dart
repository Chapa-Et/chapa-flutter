class ChapaUrl {
  static const String baseUrl =
      "https://api.chapa.co/v1/transaction/mobile-initialize";
  static const String chargeCardUrl = "charges?type=card";
  static const String defaultRedirectUrl = "https://chapa.co/";
  static const String verifyTransaction =
      "https://api.chapa.co/v1/transaction/verify/";

  static const String initiateDirectCharge = "/charges";
  static const String validateDirectCharge = "/validate";
  static const String verifyDirectCharge = "/verify/";
  static const String baseURL = "https://api.chapa.co/v1/";

  static String getBaseUrl(final bool isDebugMode) {
    return baseUrl;
  }
}
