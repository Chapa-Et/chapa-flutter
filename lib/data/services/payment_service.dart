import 'package:chapasdk/constants/direct_charge_success_response.dart';
import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/constants/extentions.dart';
import 'package:chapasdk/constants/initiate_payment.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:chapasdk/data/api_client.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/model/request/validate_directCharge_request.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/data/model/response/verify_direct_charge_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class PaymentService {
  ApiClient apiClient = ApiClient(dio: Dio(), connectivity: Connectivity());
  Future<NetworkResponse> initializeDirectPayment({
    required DirectChargeRequest request,
    required String publicKey,
    required LocalPaymentMethods localPaymentMethods,
  }) async {
    return apiClient.request(
      requestType: RequestType.post,
      path: ChapaUrl.initiateDirectCharge,
      requiresAuth: true,
      data: request.toJson(),
      queryParameters: {
        'type': localPaymentMethods.value(),
      },
      fromJsonSuccess: DirectChargeSuccessResponse.fromJson,
      fromJsonError: DirectChargeApiError.fromJson,
      publicKey: publicKey,
    );
  }

  Future validatePayment({
    required ValidateDirectChargeRequest body,
    required String publicKey,
    required LocalPaymentMethods localPaymentMethods,
  }) async {
    return apiClient.request(
      requestType: RequestType.post,
      path: ChapaUrl.validateDirectCharge,
      data: body.toJson(),
      requiresAuth: true,
      queryParameters: {
        'type': localPaymentMethods.value(),
      },
      fromJsonSuccess: ValidateDirectChargeResponse.fromJson,
      fromJsonError: ApiErrorResponse.fromJson,
      publicKey: publicKey,
    );
  }
}
