import 'package:chapasdk/domain/constants/app_images.dart';
import 'package:chapasdk/domain/constants/enums.dart';
import 'package:intl/intl.dart';

extension PaymentTypeExtention on LocalPaymentMethods {
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

  VerificationType verificationType() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return VerificationType.ussd;
      case LocalPaymentMethods.mpessa:
        return VerificationType.ussd;
      case LocalPaymentMethods.ebirr:
        return VerificationType.ussd;
      case LocalPaymentMethods.cbebirr:
        return VerificationType.ussd;
    }
  }

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

extension StringExtention on String {
  String formattedBirr() {
    var noSymbolInUSFormat = NumberFormat.compactCurrency(locale: "am");

    String amount = this;
    return noSymbolInUSFormat.format(double.parse(amount));
  }

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

  PaymentStatus parsePaymentStatus() {
    {
      switch (this) {
        case "pending":
          return PaymentStatus.pending;

        default:
          return PaymentStatus.pending;
      }
    }
  }
}

extension VerificationTypeExtention on VerificationType {
  String getVerificationTypeValue() {
    switch (this) {
      case VerificationType.otp:
        return "otp";
      case VerificationType.ussd:
        return "ussd";
    }
  }
}

List<LocalPaymentMethods> getFilteredPaymentMethods(List<String> filterValues) {
  return LocalPaymentMethods.values.where((paymentMethod) {
    return filterValues.any((filter) => filter == paymentMethod.value());
  }).toList();
}

extension DateExtention on DateTime {
  String format() {
    return DateFormat('EEE, MMM d yyyy, h:mm a').format(
      this,
    );
  }
}
