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

/// A service class responsible for handling payment-related operations, such as
/// initiating payments and verifying payments, by interacting with the API.
class PaymentService {
  /// The [ApiClient] instance used for making API requests.
  ApiClient apiClient = ApiClient(dio: Dio(), connectivity: Connectivity());

  ///
  /// Initializes a direct payment request.
  /// This method sends a request to the API to initialize a direct payment.
  /// Returns a [NetworkResponse] containing the result of the payment initiation.
  Future<NetworkResponse> initializeDirectPayment({
    /// [request]: The [DirectChargeRequest] object that contains the payment details.
    required DirectChargeRequest request,

    /// [publicKey]: The public key required for the API request.
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

  ///
  /// Verifies a payment by checking its status.
  /// This method sends a request to the API to verify the status of a payment.
  /// Returns a [NetworkResponse] containing the result of the payment verification.
  Future<NetworkResponse> verifyPayment({
    /// [body]: The [ValidateDirectChargeRequest] object that contains the necessary data for verification
    required ValidateDirectChargeRequest body,

    /// [publicKey]: The public key required for the API request.
    required String publicKey,
  }) async {
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
