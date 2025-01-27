import 'package:bloc/bloc.dart';
import 'package:chapasdk/data/model/initiate_payment.dart';
import 'package:chapasdk/data/model/response/direct_charge_success_response.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/model/request/validate_direct_charge_request.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/data/model/response/verify_direct_charge_response.dart';
import 'package:chapasdk/data/services/payment_service.dart';
import 'package:meta/meta.dart';

part 'chapa_native_checkout_event.dart';
part 'chapa_native_checkout_state.dart';

class ChapaNativeCheckoutBloc
    extends Bloc<ChapaNativeCheckoutEvent, ChapaNativeCheckoutState> {
  PaymentService paymentService;
  ChapaNativeCheckoutBloc({required this.paymentService})
      : super(ChapaNativeCheckoutInitial()) {
    on<ChapaNativeCheckoutEvent>((event, emit) {
      emit(ChapaNativeCheckoutInitial());
    });
    on<InitiatePayment>((event, emit) async {
      emit(ChapaNativeCheckoutLoadingState());
      try {
        NetworkResponse networkResponse =
            await paymentService.initializeDirectPayment(
          request: event.directChargeRequest,
          publicKey: event.publicKey,
        );

        if (networkResponse is Success) {
          DirectChargeSuccessResponse directChargeSuccessResponse =
              networkResponse.body;
          String reference =
              directChargeSuccessResponse.data!.meta!.refId ?? "";

          if (reference.isNotEmpty) {
            add(ValidatePayment(
              validateDirectChargeRequest: ValidateDirectChargeRequest(
                  reference: reference,
                  mobile: event.directChargeRequest.mobile,
                  paymentMethod: event.directChargeRequest.paymentMethod),
              publicKey: event.publicKey,
            ));
          }
        } else if (networkResponse is ApiError) {
          try {
            DirectChargeApiError directChargeApiError = networkResponse.error;
            emit(ChapaNativeCheckoutPaymentInitiateApiError(
              directChargeApiError: directChargeApiError,
            ));
          } catch (e) {
            ApiErrorResponse apiErrorResponse = networkResponse.error;

            emit(ChapaNativeCheckoutPaymentInitiateApiError(
              apiErrorResponse: apiErrorResponse,
            ));
          }
        } else if (networkResponse is NetworkError) {
          emit(ChapaNativeCheckoutNetworkError());
        } else if (networkResponse is UnknownError) {
          emit(ChapaNativeCheckoutUnknownError());
        } else {
          emit(ChapaNativeCheckoutUnknownError());
        }
      } catch (e) {
        emit(ChapaNativeCheckoutUnknownError());
      }
    });
    on<ValidatePayment>((event, emit) async {
      emit(ChapaNativeCheckoutValidationOngoingState());
      try {
        NetworkResponse networkResponse = await paymentService.verifyPayment(
          body: event.validateDirectChargeRequest,
          publicKey: event.publicKey,
        );
        if (networkResponse is Success) {
          ValidateDirectChargeResponse verifyResult = networkResponse.body;
          if (verifyResult.data?.status == "success") {
            emit(ChapaNativeCheckoutPaymentValidateSuccessState(
              directChargeValidateResponse: networkResponse.body,
              isPaymentFailed: false,
            ));
          } else if (verifyResult.data?.status == "pending") {
            add(ValidatePayment(
              validateDirectChargeRequest: event.validateDirectChargeRequest,
              publicKey: event.publicKey,
            ));
          } else {
            emit(ChapaNativeCheckoutPaymentValidateSuccessState(
                directChargeValidateResponse: networkResponse.body,
                isPaymentFailed: true));
          }
        } else if (networkResponse is ApiError) {
          emit(ChapaNativeCheckoutPaymentValidateApiError(
              apiErrorResponse: networkResponse.error));
        } else if (networkResponse is NetworkError) {
          emit(ChapaNativeCheckoutNetworkError());
        } else {
          emit(ChapaNativeCheckoutUnknownError());
        }
      } catch (e) {
        emit(ChapaNativeCheckoutUnknownError());
      }
    });
  }
}
