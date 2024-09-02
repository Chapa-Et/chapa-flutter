import 'package:chapasdk/constants/enums.dart';

extension PaymentTypeExtention on LocalPaymentMethods {
  String displayName() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return "Telebirr";
      case LocalPaymentMethods.cbebirr:
        return "CBEBirr";
      case LocalPaymentMethods.mpessa:
        return "M-Pesa";
      case LocalPaymentMethods.amole:
        return "Amole";
      case LocalPaymentMethods.ebirr:
        return "Ebirr";

      case LocalPaymentMethods.awashbirr:
        return "Awash birr";
      default:
        return "Telebirr";
    }
  }

  String value() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return "telebirr";
      case LocalPaymentMethods.mpessa:
        return "mpesa";
      case LocalPaymentMethods.amole:
        return "amole";
      case LocalPaymentMethods.ebirr:
        return "ebirr";
      case LocalPaymentMethods.cbebirr:
        return "cbebirr";
      case LocalPaymentMethods.awashbirr:
        return "awash_birr";
      default:
        return "telebirr";
    }
  }

  VerificationType verificationType() {
    switch (this) {
      case LocalPaymentMethods.telebirr:
        return VerificationType.ussd;
      case LocalPaymentMethods.mpessa:
        return VerificationType.otp;
      case LocalPaymentMethods.amole:
        return VerificationType.otp;
      case LocalPaymentMethods.ebirr:
        return VerificationType.ussd;
      case LocalPaymentMethods.cbebirr:
        return VerificationType.ussd;
      case LocalPaymentMethods.awashbirr:
        return VerificationType.otp;
      default:
        return VerificationType.ussd;
    }
  }
}

extension StringExtention on String? {
  VerificationType parseAuthDataType() {
    if (this == null) {
      return VerificationType.otp;
    } else {
      switch (this) {
        case "ussd":
          return VerificationType.ussd;
        case "otp":
          return VerificationType.otp;
        default:
          return VerificationType.otp;
      }
    }
  }

  Mode parseMode() {
    if (this == null) {
      return Mode.testing;
    } else {
      switch (this) {
        case "live":
          return Mode.live;
        case "testing":
          return Mode.testing;
        default:
          return Mode.testing;
      }
    }
  }

  PaymentStatus parsePaymentStatus() {
    if (this == null) {
      return PaymentStatus.pending;
    } else {
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
      default:
        return "ussd";
    }
  }
}
