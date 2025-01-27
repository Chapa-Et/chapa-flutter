part of 'chapa_native_checkout_bloc.dart';

/// Base class for all states in the ChapaNativeCheckoutBloc.
@immutable
sealed class ChapaNativeCheckoutState {}

/// Initial state when the payment flow has not yet started.
final class ChapaNativeCheckoutInitial extends ChapaNativeCheckoutState {}

/// State indicating that the payment process is loading.
final class ChapaNativeCheckoutLoadingState extends ChapaNativeCheckoutState {}

/// State representing a successful payment initiation.
/// 
/// Contains the response from the payment service after a successful
/// initiation of a payment.
final class ChapaNativeCheckoutPaymentInitiateSuccessState
    extends ChapaNativeCheckoutState {
  
  /// The response received from the payment service after a successful payment initiation.
  final DirectChargeSuccessResponse directChargeSuccessResponse;

  /// Constructor for the [ChapaNativeCheckoutPaymentInitiateSuccessState].
  ///
  /// [directChargeSuccessResponse]: The response object that contains the result of the payment initiation.
  ChapaNativeCheckoutPaymentInitiateSuccessState({
    required this.directChargeSuccessResponse,
  });
}


/// State representing an error that occurred during the payment initiation.
/// 
/// It can contain either an API error response or a direct charge API error response.
// ignore: must_be_immutable
final class ChapaNativeCheckoutPaymentInitiateApiError
    extends ChapaNativeCheckoutState {
  
  /// The error response from the API (if any).
  ApiErrorResponse? apiErrorResponse;
  
  /// The direct charge API error response (if any).
  DirectChargeApiError? directChargeApiError;

  /// Constructor for the [ChapaNativeCheckoutPaymentInitiateApiError].
  ///
  /// [apiErrorResponse]: The error response from the API.
  /// [directChargeApiError]: The direct charge API error response.
  ChapaNativeCheckoutPaymentInitiateApiError({
    this.apiErrorResponse,
    this.directChargeApiError,
  });
}

// Validating

/// State indicating that payment validation is ongoing.
final class ChapaNativeCheckoutValidationOngoingState
    extends ChapaNativeCheckoutState {}

/// State representing the success of payment validation.
/// 
/// Contains the response from the validation service and a flag indicating
/// whether the payment failed or not.
final class ChapaNativeCheckoutPaymentValidateSuccessState
    extends ChapaNativeCheckoutState {
  
  /// The response received from the payment validation service.
  final ValidateDirectChargeResponse directChargeValidateResponse;
  
  /// A flag indicating whether the payment failed (true if failed, false otherwise).
  final bool isPaymentFailed;

  /// Constructor for the [ChapaNativeCheckoutPaymentValidateSuccessState].
  ///
  /// [directChargeValidateResponse]: The response from the payment validation.
  /// [isPaymentFailed]: A flag indicating whether the payment failed.
  ChapaNativeCheckoutPaymentValidateSuccessState({
    required this.directChargeValidateResponse,
    required this.isPaymentFailed,
  });
}

/// State representing an error that occurred during the payment validation.
/// 
/// It contains the API error response (if any) from the validation request.
// ignore: must_be_immutable
final class ChapaNativeCheckoutPaymentValidateApiError
    extends ChapaNativeCheckoutState {
  
  /// The error response from the API (if any).
  ApiErrorResponse? apiErrorResponse;

  /// Constructor for the [ChapaNativeCheckoutPaymentValidateApiError].
  ///
  /// [apiErrorResponse]: The error response from the API during validation.
  ChapaNativeCheckoutPaymentValidateApiError({
    this.apiErrorResponse,
  });
}

/// State representing an unknown error that occurred during the checkout process.
final class ChapaNativeCheckoutUnknownError extends ChapaNativeCheckoutState {}

/// State representing a network error during the checkout process.
final class ChapaNativeCheckoutNetworkError extends ChapaNativeCheckoutState {}
