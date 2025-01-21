import 'package:chapasdk/features/native-checkout/chapa_native_payment.dart';
import 'package:flutter/material.dart';
import 'package:chapasdk/domain/constants/common.dart';
import 'package:chapasdk/domain/constants/requests.dart';
import 'package:chapasdk/domain/constants/strings.dart';

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

  final Color? buttonColor;

  final bool? showPaymentMethodsOnGridView;
  List<String>? availablePaymentMethods;

  Function(String,String,String)? onPaymentFinished;

  Chapa.paymentParameters({
    required this.context,
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
    this.buttonColor,
    this.showPaymentMethodsOnGridView,
    this.availablePaymentMethods,
    this.onPaymentFinished,
  
  }) {
    _validateKeys();
    currency = currency.toUpperCase();
    if (_validateKeys()) {
      initiatePayment();
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

  void initiatePayment() async {
    if (nativeCheckout) {
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
              buttonColor: buttonColor,
              showPaymentMethodsOnGridView: showPaymentMethodsOnGridView,
              availablePaymentMethods: availablePaymentMethods ?? [],
              onPaymentFinished: onPaymentFinished,
            ),
          ));
    } else {
      await initializeMyPayment(
        context,
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
        publicKey,
        onPaymentFinished
      );
    }
  }
}
