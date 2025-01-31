import 'dart:math';
import 'package:chapasdk/domain/constants/app_images.dart';
import 'package:chapasdk/domain/constants/enums.dart';
import 'package:intl/intl.dart';

/// Extension on `LocalPaymentMethods` enum to provide additional functionality.
extension PaymentTypeExtension on LocalPaymentMethods {
  /// Returns the display name of the payment method.
  String displayName() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return "Telebirr";
      case LocalPaymentMethods.cbebirr:
        return "CBEBirr";
      case LocalPaymentMethods.mpessa:
        return "M-Pesa";
      case LocalPaymentMethods.ebirr:
        return "Ebirr";
    }
  }

  /// Returns the string value of the payment method.
  String value() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return "telebirr";
      case LocalPaymentMethods.mpessa:
        return "mpesa";
      case LocalPaymentMethods.ebirr:
        return "ebirr";
      case LocalPaymentMethods.cbebirr:
        return "cbebirr";
    }
  }

  /// Returns the `VerificationType` associated with the payment method.
  VerificationType verificationType() {
    return VerificationType
        .ussd; // All methods default to USSD in this implementation.
  }

  /// Returns the icon path for the payment method.
  String iconPath() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return AppImages.telebirr;
      case LocalPaymentMethods.mpessa:
        return AppImages.mpesa;
      case LocalPaymentMethods.ebirr:
        return AppImages.ebirr;
      case LocalPaymentMethods.cbebirr:
        return AppImages.cbebirr;
    }
  }
}

/// Extension on `String` to provide additional utility methods.
extension StringExtension on String {
  /// Formats the string as Ethiopian Birr currency.
  String formattedBirr() {
    var noSymbolInUSFormat = NumberFormat.compactCurrency(locale: "am");
    return noSymbolInUSFormat.format(double.parse(this));
  }

  /// Parses the string into a `VerificationType`.
  VerificationType parseAuthDataType() {
    switch (this) {
      case "ussd":
        return VerificationType.ussd;
      case "otp":
        return VerificationType.otp;
      default:
        return VerificationType.otp;
    }
  }

  /// Parses the string into a `Mode`.
  Mode parseMode() {
    switch (this) {
      case "live":
        return Mode.live;
      case "testing":
        return Mode.testing;
      default:
        return Mode.testing;
    }
  }

  /// Parses the string into a `PaymentStatus`.
  PaymentStatus parsePaymentStatus() {
    switch (this) {
      case "pending":
        return PaymentStatus.pending;
      default:
        return PaymentStatus
            .pending; // Defaults to pending in this implementation.
    }
  }
}

/// Extension on `VerificationType` to provide additional functionality.
extension VerificationTypeExtension on VerificationType {
  /// Returns the string value of the `VerificationType`.
  String getVerificationTypeValue() {
    switch (this) {
      case VerificationType.otp:
        return "otp";
      case VerificationType.ussd:
        return "ussd";
    }
  }
}

/// Filters `LocalPaymentMethods` based on a list of string values.
List<LocalPaymentMethods> getFilteredPaymentMethods(List<String> filterValues) {
  return LocalPaymentMethods.values.where((paymentMethod) {
    return filterValues.any((filter) =>
        filter.toLowerCase() == paymentMethod.value().toLowerCase());
  }).toList();
}

/// Extension on `DateTime` to provide additional formatting functionality.
extension DateExtension on DateTime {
  /// Formats the `DateTime` to a readable string.
  String format() {
    return DateFormat('EEE, MMM d yyyy, h:mm a').format(this);
  }
}

/// Generates a random transaction reference string.
String generateTransactionRef() {
  var r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(10, (index) => chars[r.nextInt(chars.length)]).join();
}
