part of 'chapa_native_checkout_bloc.dart';

/// Base class for all events in the ChapaNativeCheckoutBloc.
@immutable
sealed class ChapaNativeCheckoutEvent {}

// ignore: must_be_immutable
/// Event triggered to initiate the payment process.
///
/// Contains the payment request data and the public key required for the payment.
class InitiatePayment extends ChapaNativeCheckoutEvent {
  /// The request data needed to initialize a direct charge payment.
  final DirectChargeRequest directChargeRequest;

  /// The public key used to authenticate the payment request with the Chapa API.
  final String publicKey;

  /// Constructor for the [InitiatePayment] event.
  ///
  /// [directChargeRequest]: The request object that contains payment details.
  /// [publicKey]: The public key used for authentication with the Chapa API.
  InitiatePayment({
    required this.directChargeRequest,
    required this.publicKey,
  });
}

// ignore: must_be_immutable
/// Event triggered to validate a payment after initiation.
///
/// Contains the request data to verify the payment status and the public key.
class ValidatePayment extends ChapaNativeCheckoutEvent {
  /// The request data needed to validate the direct charge payment.
  final ValidateDirectChargeRequest validateDirectChargeRequest;

  /// The public key used to authenticate the payment validation with the Chapa API.
  final String publicKey;

  /// Constructor for the [ValidatePayment] event.
  ///
  /// [validateDirectChargeRequest]: The request object containing reference and
  /// other details to validate the payment.
  /// [publicKey]: The public key used for authentication with the Chapa API.
  ValidatePayment({
    required this.validateDirectChargeRequest,
    required this.publicKey,
  });
}
