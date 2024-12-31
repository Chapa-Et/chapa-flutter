part of 'chapa_native_checkout_bloc.dart';

@immutable
sealed class ChapaNativeCheckoutEvent {}

// ignore: must_be_immutable
class InitiatePayment extends ChapaNativeCheckoutEvent {
  DirectChargeRequest directChargeRequest;
  String publicKey;

  InitiatePayment({
    required this.directChargeRequest,
    required this.publicKey,

  });
}

// ignore: must_be_immutable
class ValidatePayment extends ChapaNativeCheckoutEvent {
  ValidateDirectChargeRequest validateDirectChargeRequest;
  String publicKey;

  ValidatePayment({
    required this.validateDirectChargeRequest,
    required this.publicKey,

  });
}
