part of 'chapa_native_checkout_bloc.dart';

@immutable
sealed class ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutInitial extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutLoadingState extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutPaymentInitiateSuccessState
    extends ChapaNativeCheckoutState {
  final DirectChargeSuccessResponse directChargeSuccessResponse;

  ChapaNativeCheckoutPaymentInitiateSuccessState({
    required this.directChargeSuccessResponse,
  });
}

// ignore: must_be_immutable
final class ChapaNativeCheckoutPaymentInitiateApiError  extends ChapaNativeCheckoutState {
  ApiErrorResponse? apiErrorResponse;
  DirectChargeApiError? directChargeApiError;
  ChapaNativeCheckoutPaymentInitiateApiError({
    this.apiErrorResponse,
    this.directChargeApiError,
  });
}

// Validating

final class ChapaNativeCheckoutValidationOngoingState
    extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutPaymentValidateSuccessState
    extends ChapaNativeCheckoutState {
  final ValidateDirectChargeResponse directChargeValidateResponse;
  final bool isPaymentFailed;
  ChapaNativeCheckoutPaymentValidateSuccessState({
    required this.directChargeValidateResponse,
    required this.isPaymentFailed,
  });
}

// ignore: must_be_immutable
final class ChapaNativeCheckoutPaymentValidateApiError
    extends ChapaNativeCheckoutState {
  ApiErrorResponse? apiErrorResponse;

  ChapaNativeCheckoutPaymentValidateApiError({
    this.apiErrorResponse,
  });
}

final class ChapaNativeCheckoutUnknownError extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutNetworkError extends ChapaNativeCheckoutState {}
