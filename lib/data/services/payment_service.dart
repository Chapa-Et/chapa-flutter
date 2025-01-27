import 'package:chapasdk/data/model/initiate_payment.dart';
import 'package:chapasdk/data/model/response/direct_charge_success_response.dart';
import 'package:chapasdk/domain/constants/enums.dart';
import 'package:chapasdk/domain/constants/url.dart';
import 'package:chapasdk/data/api_client.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:chapasdk/data/model/request/validate_direct_charge_request.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/data/model/response/verify_direct_charge_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class PaymentService {
  ApiClient apiClient = ApiClient(dio: Dio(), connectivity: Connectivity());
  Future<NetworkResponse> initializeDirectPayment({
    required DirectChargeRequest request,
    required String publicKey,
  }) async {
    return apiClient.request(
      requestType: RequestType.post,
      path: ChapaUrl.directCharge,
      requiresAuth: true,
      data: request.toJson(),
      fromJsonSuccess: DirectChargeSuccessResponse.fromJson,
      fromJsonError: DirectChargeApiError.fromJson,
      publicKey: publicKey,
    );
  }

  Future<NetworkResponse> verifyPayment(
      {required ValidateDirectChargeRequest body,
      required String publicKey}) async {
    return apiClient.request(
      requestType: RequestType.post,
      requiresAuth: true,
      path: ChapaUrl.verifyUrl,
      data: body.toJson(),
      fromJsonSuccess: ValidateDirectChargeResponse.fromJson,
      fromJsonError: ApiErrorResponse.fromJson,
      publicKey: publicKey,
    );
  }
}
