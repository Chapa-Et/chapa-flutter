import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chapasdk/constants/direct_charge_success_response.dart';
import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/model/request/validate_directCharge_request.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
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
                localPaymentMethods: event.selectedLocalPaymentMethods);
        
        if (networkResponse is Success) {
          DirectChargeSuccessResponse directChargeSuccessResponse =
              networkResponse.body;
          if (directChargeSuccessResponse.data?.authDataType ==
              VerificationType.ussd) {
            add(ValidatePayment(
              validateDirectChargeRequest: ValidateDirectChargeRequest(
                client: "",
                referenceId: event.directChargeRequest.txRef,
              ),
              publicKey: event.publicKey,
              selectedLocalPaymentMethods: event.selectedLocalPaymentMethods,
            ));
          } else {
            emit(ChapaNativeCheckoutPaymentInitateSuccessOTPRequestState(
                directChargeSuccessResponse: directChargeSuccessResponse));
          }
        } else if (networkResponse is ApiError) {
          emit(ChapaNativeCheckoutApiError(
              apiErrorResponse: networkResponse.error));
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
      const interval = Duration(seconds: 3);
      const totalDuration = Duration(minutes: 5);
      Timer.periodic(interval, (Timer t) async {
        if (t.tick >= totalDuration.inSeconds ~/ interval.inSeconds) {
          t.cancel();
          emit(ChapaNativeCheckoutTimeout());
        } else {
          try {
            NetworkResponse networkResponse =
                await paymentService.validatePayment(
              body: event.validateDirectChargeRequest,
              publicKey: event.publicKey,
              localPaymentMethods: event.selectedLocalPaymentMethods,
            );
            if (networkResponse is Success) {
            } else if (networkResponse is ApiError) {
              emit(ChapaNativeCheckoutApiError(
                  apiErrorResponse: networkResponse.error));
              t.cancel();
            } else if (networkResponse is NetworkError) {
              t.cancel();
              emit(ChapaNativeCheckoutNetworkError());
            } else {
              t.cancel();
              emit(ChapaNativeCheckoutNetworkError());
            }
          } catch (e) {
            t.cancel();
            emit(ChapaNativeCheckoutNetworkError());
          }
        }
      });
    });
  }
}
