part of 'chapa_native_checkout_bloc.dart';

@immutable
sealed class ChapaNativeCheckoutEvent {}

// ignore: must_be_immutable
class InitiatePayment extends ChapaNativeCheckoutEvent {
  DirectChargeRequest directChargeRequest;
  String publicKey;
  LocalPaymentMethods selectedLocalPaymentMethods;

  InitiatePayment({
    required this.directChargeRequest,
    required this.publicKey,
    required this.selectedLocalPaymentMethods,
  });
}

// ignore: must_be_immutable
class ValidatePayment extends ChapaNativeCheckoutEvent {
  ValidateDirectChargeRequest validateDirectChargeRequest;
  String publicKey;
  LocalPaymentMethods selectedLocalPaymentMethods;
  ValidatePayment({
    required this.validateDirectChargeRequest,
    required this.publicKey,
    required this.selectedLocalPaymentMethods,
  });
}
