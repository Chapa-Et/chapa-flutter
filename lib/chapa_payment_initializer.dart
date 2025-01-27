import 'package:chapasdk/features/native-checkout/chapa_native_payment.dart';
import 'package:flutter/material.dart';
import 'package:chapasdk/domain/constants/common.dart';
import 'package:chapasdk/domain/constants/requests.dart';
import 'package:chapasdk/domain/constants/strings.dart';

/// The Chapa class provides functionality for integrating payments using the Chapa SDK.
///
/// This class handles payment initialization, parameter validation, and routing to the appropriate
/// payment method (native or web-based).
class Chapa {
  /// The BuildContext for navigation and UI rendering.
  BuildContext context;

  /// Public API key required for Merchant authentication.
  String publicKey;

  /// Payment amount.
  String amount;

  /// Payment currency (e.g., USD, ETB). Ensured to be uppercase.
  String currency;

  /// Customer's email address.
  String email;

  /// Customer's phone number.
  String phone;

  /// Customer's first name.
  String firstName;

  /// Customer's last name.
  String lastName;

  /// Transaction reference, a unique identifier for the payment.
  String txRef;

  /// Payment title
  String title;

  /// Payment description
  String desc;

  /// The fallback named route after the payment is made.
  String namedRouteFallBack;

  /// The boolean values which Indicates whether to use the native checkout or web
  bool nativeCheckout;

  /// Custom button color for the checkout.
  final Color? buttonColor;

  /// Option to show payment methods in a grid view.
  final bool? showPaymentMethodsOnGridView;

  /// List of available payment methods. If null, all methods are enabled.
  List<String>? availablePaymentMethods;

  /// Callback triggered when the payment process finishes.
  ///
  /// Return the transaction status, reference, and response as arguments.
  Function(String, String, String)? onPaymentFinished;

  /// Constructs a Chapa object with the required payment parameters.
  ///
  /// Throws a validation error if any mandatory parameter is missing or invalid.
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

  /// Validates the mandatory payment parameters.
  ///
  /// Displays a toast message if any parameter is invalid.
  /// Returns `true` if all keys are valid, otherwise `false`.
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

  /// Initiates the payment process based on the [nativeCheckout] flag.
  ///
  /// Navigates to the native checkout  if [nativeCheckout] is `true`.
  /// Otherwise, initializes a web-checkout.
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
        onPaymentFinished,
      );
    }
  }
}
