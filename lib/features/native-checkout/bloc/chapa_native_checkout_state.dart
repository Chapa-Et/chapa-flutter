part of 'chapa_native_checkout_bloc.dart';

@immutable
sealed class ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutInitial extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutLoadingState extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutPaymentInitateSuccessState
    extends ChapaNativeCheckoutState {
  final DirectChargeSuccessResponse directChargeSuccessResponse;

  ChapaNativeCheckoutPaymentInitateSuccessState({
    required this.directChargeSuccessResponse,
  });
}

final class ChapaNativeCheckoutPaymentInitateSuccessOTPRequestState
    extends ChapaNativeCheckoutState {
  final DirectChargeSuccessResponse directChargeSuccessResponse;

  ChapaNativeCheckoutPaymentInitateSuccessOTPRequestState({
    required this.directChargeSuccessResponse,
  });
}

final class ChapaNativeCheckoutValidationOngoingState
    extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutPaymentValidateSuccessState
    extends ChapaNativeCheckoutState {}

// ignore: must_be_immutable
final class ChapaNativeCheckoutApiError extends ChapaNativeCheckoutState {
  ApiErrorResponse apiErrorResponse;
  ChapaNativeCheckoutApiError({
    required this.apiErrorResponse,
  });
}

final class ChapaNativeCheckoutUnknownError extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutNetworkError extends ChapaNativeCheckoutState {}

final class ChapaNativeCheckoutTimeout extends ChapaNativeCheckoutState {}
