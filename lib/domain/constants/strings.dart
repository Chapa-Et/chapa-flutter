/// A class that contains constant string values used throughout the application.
/// These strings are used for validation messages and error handling.
class ChapaStrings {
  /// Message displayed when the public key is missing or not provided.
  static const publicKeyRequired = 'Public key is required';

  /// Message displayed when the currency is missing or not provided.
  static const currencyRequired = 'Currency is required';

  /// Message displayed when the amount is missing or not provided.
  static const amountRequired = 'Amount is required';

  /// Message displayed when the transaction reference is missing or not provided.
  static const transactionRefrenceRequired =
      'Transaction Reference is required';

  /// Message displayed when there is a connectivity issue (e.g., no internet connection).
  static const connectionError = 'Connectivity Issue';
}
