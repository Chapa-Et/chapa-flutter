import 'package:chapasdk/constants/enums.dart';
import 'package:chapasdk/constants/extentions.dart';
import 'package:chapasdk/constants/url.dart';
import 'package:chapasdk/data/api_client.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:chapasdk/data/model/request/direct_charge_request.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class PaymentService {
  ApiClient apiClient = ApiClient(dio: Dio(), connectivity: Connectivity());
  Future<NetworkResponse> initializeDirectPayment(
      {required DirectChargeRequest request,
      required String publicKey,
      required LocalPaymentMethods localPaymentMethods}) async {
    return apiClient.request(
      requestType: RequestType.post,
      path: ChapaUrl.initiateDirectCharge,
      requiresAuth: true,
      data: request.toJson(),
      queryParameters: {
        'type': localPaymentMethods.getValue(),
      },
      fromJsonSuccess: (val) {
        print(val);
      },
      fromJsonError: (error, code) {
        print(error);
      },
      publicKey: publicKey,
    );
  }

  Future validateDirectPayment() async {}
  Future verifyDirectPayment() async {}
}
