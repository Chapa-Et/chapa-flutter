import 'dart:async';
import 'dart:io';
import 'package:chapasdk/domain/constants/enums.dart';
import 'package:chapasdk/data/dio_client.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/data/model/response/api_response.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

/// A client for making network requests with built-in error handling and
/// support for various request types.
///
/// This class uses Custom Dio Client for HTTP requests and supports functionalities such
/// as adding authorization headers, including default parameters, and
/// transforming responses using custom serializers.
class ApiClient {
  /// The Custom Dio client for making HTTP requests.
  late DioClient dioClient;

  /// The underlying Dio instance for configuration and advanced use cases.
  final Dio dio;

  /// Provides network connectivity status.
  final Connectivity connectivity;

  /// Default parameters to include in every request.
  ///
  /// These parameters are automatically appended to the request body
  /// when [requiresDefaultParams] is true in the [request] method.
  Map<String, dynamic> defaultParams = {};

  /// Creates an instance of [ApiClient].
  ///
  /// Requires a [dio] instance for HTTP requests and a [connectivity] instance
  /// for monitoring network status.
  ApiClient({
    required this.dio,
    required this.connectivity,
  }) {
    dioClient = DioClient(dio, connectivity: connectivity);
  }

  /// Sends an HTTP request and handles the response.
  ///
  /// Supports GET, POST, PATCH, DELETE, and PUT request types, with options
  /// for adding authorization headers, default parameters, and custom
  /// serialization for success and error responses.

  Future<NetworkResponse> request<T, U>({
    /// - [requestType]: The type of HTTP request (e.g., GET, POST From Enum Value).
    required RequestType requestType,

    /// - [requiresAuth]: Whether the request requires an authorization header or not.
    bool requiresAuth = true,

    /// - [requiresDefaultParams]: Whether to include [defaultParams] in the request body.
    bool requiresDefaultParams = true,

    /// - [path]: The endpoint path for the request.
    required String path,

    /// - [queryParameters]: Optional query parameters.
    Map<String, dynamic>? queryParameters,

    /// - [data]: Optional request body.
    Map<String, dynamic>? data,

    /// - [headers]: Optional additional headers.
    Map<String, dynamic>? headers,

    /// - [isBodyJsonToString]: Whether to encode the body as a JSON string.
    bool isBodyJsonToString = false,

    /// - [jsonToStringBody]: The pre-encoded JSON string body, used if [isBodyJsonToString] is true.
    String jsonToStringBody = "",

    /// - [fromJsonSuccess]: A custom function to parse the success response into a model.
    required T Function(Map<String, dynamic>) fromJsonSuccess,

    /// - [fromJsonError]: A function to parse the error response into a model.
    required U Function(Map<String, dynamic>, int) fromJsonError,

    /// - [publicKey]: The public key for merchant authorization,
    required String publicKey,
  }) async {
    try {
      // Add authorization header if required.
      if (requiresAuth) {
        await dioClient.addAuthorizationInterceptor(publicKey);
      }

      // Include default parameters if applicable.
      if (requiresDefaultParams && data != null) {
        data = Map<String, dynamic>.from(data);
        data.addAll(defaultParams);
      }

      Options? options;

      dynamic response;

      // Execute the request based on the specified type.
      switch (requestType) {
        case RequestType.get:
          response = await dioClient.get(path,
              options: options, queryParameters: queryParameters);
          break;
        case RequestType.post:
          response = await dioClient.post(
            path,
            options: options,
            data: isBodyJsonToString ? jsonToStringBody : data,
            queryParameters: queryParameters,
          );
          break;
        case RequestType.patch:
          response = await dioClient.patch(path, options: options, data: data);
          break;
        case RequestType.delete:
          response = await dioClient.delete(path, options: options);
          break;
        case RequestType.put:
          response = await dioClient.put(path, options: options, data: data);
          break;
      }
      try {
        if (response == null) {
          return Success(
              body: ApiResponse(
            code: 200,
            message: "Success",
          ));
        }
        final successResponse = fromJsonSuccess(response);
        return Success(body: successResponse);
      } catch (e) {
        return Success(
            body: ApiResponse(
          code: 200,
          message: "Success",
        ));
      }
    } on DioException catch (e) {
      try {
        switch (e.type) {
          case DioExceptionType.connectionError:
            return NetworkError(
              error: SocketException(e.message ?? ""),
            );

          case DioExceptionType.badResponse:
            try {
              return ApiError(
                error: fromJsonError(
                  e.response!.data,
                  e.response!.statusCode!,
                ),
                code: e.response!.statusCode!,
              );
            } catch (error) {
              return ApiError(
                error: ApiErrorResponse.fromJson(
                  e.response!.data,
                  e.response!.statusCode!,
                ),
                code: e.response!.statusCode!,
              );
            }

          default:
            return UnknownError(error: e);
        }
      } catch (exception) {
        return ApiError(error: e.response!.data, code: e.response!.statusCode!);
      }
    } catch (e) {
      return UnknownError(error: e);
    }
  }
}
