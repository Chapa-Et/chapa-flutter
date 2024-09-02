import 'package:chapasdk/features/native-checkout/chapa_native_payment.dart';
import 'package:flutter/material.dart';
import 'constants/common.dart';
import 'constants/requests.dart';
import 'constants/strings.dart';

class Chapa {
  BuildContext context;
  String publicKey;
  String amount;
  String currency;
  String email;
  String phone;
  String firstName;
  String lastName;
  String txRef;
  String title;
  String desc;
  String namedRouteFallBack;
  bool nativeCheckout;
  bool defaultCheckout;
  String encryptionKey;

  Chapa.paymentParameters(
      {required this.context,
      required this.publicKey,
      required this.currency,
      required this.amount,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.txRef,
      required this.title,
      required this.desc,
      required this.namedRouteFallBack,
      this.nativeCheckout = false,
      this.defaultCheckout = true,
      required this.encryptionKey}) {
    _validateKeys();
    currency = currency.toUpperCase();
    if (_validateKeys()) {
      initatePayment();
    }
  }

  bool _validateKeys() {
    if (publicKey.trim().isEmpty) {
      showErrorToast(ChapaStrings.publicKeyRequired);
      return false;
    }
    if (currency.trim().isEmpty) {
      showErrorToast(ChapaStrings.currencyRequired);
      return false;
    }
    if (amount.trim().isEmpty) {
      showErrorToast(ChapaStrings.amountRequired);
      return false;
    }

    if (txRef.trim().isEmpty) {
      showErrorToast(ChapaStrings.transactionRefrenceRequired);
      return false;
    }

    return true;
  }

  void initatePayment() async {
    if (nativeCheckout || (nativeCheckout && defaultCheckout)) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChapaNativePayment(
              context: context,
              publicKey: publicKey,
              currency: currency,
              firstName: firstName,
              lastName: lastName,
              amount: amount,
              email: email,
              phone: phone,
              namedRouteFallBack: namedRouteFallBack,
              title: title,
              desc: desc,
              txRef: txRef,
              defaultCheckout: defaultCheckout,
              encryptionKey: encryptionKey,
            ),
          ));
    } else if (defaultCheckout) {
      intilizeMyPayment(
        context,
        publicKey,
        email,
        phone,
        amount,
        currency,
        firstName,
        lastName,
        txRef,
        title,
        desc,
        namedRouteFallBack,
      );
    } else {
      intilizeMyPayment(
        context,
        publicKey,
        email,
        phone,
        amount,
        currency,
        firstName,
        lastName,
        txRef,
        title,
        desc,
        namedRouteFallBack,
      );
    }
  }
}
