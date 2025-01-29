import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';

/// A custom interceptor for handling authorization and response logic in Dio.
///
/// This interceptor automatically adds a Bearer token to all outgoing requests
/// and handles token expiration by removing itself from Dio's interceptors
/// when a `401 Unauthorized` status code is encountered.
class AuthorizationInterceptor extends InterceptorsWrapper {
  /// The Dio instance used for making HTTP requests.
  final Dio dio;

  /// The public key or Bearer token used for Merchant authorization.
  final String publicKey;

  /// Constructor to initialize the interceptor with a Dio instance and a public key.
  AuthorizationInterceptor(this.dio, this.publicKey);

  /// Intercepts and modifies outgoing requests.
  ///
  /// Adds the `Authorization` header with the Bearer token to every request.
  ///
  /// - [options]: The request options containing the request details.
  /// - [handler]: The interceptor handler to continue or reject the request.
  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Add the Authorization header with the Bearer token.
      options.headers['Authorization'] = "Bearer $publicKey";
    } catch (e) {
      // Log any exceptions that occur during request modification.
      log('AuthorizationInterceptor caught an error: $e');
    }
    // Continue the request.
    return handler.next(options);
  }

  /// Intercepts and processes incoming responses.
  ///
  /// Handles `401 Unauthorized` responses by removing this interceptor
  /// and rejecting the response with a `DioException` indicating token expiration.
  ///
  /// - [response]: The HTTP response received from the server.
  /// - [handler]: The interceptor handler to continue or reject the response.
  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    // Check if the response status code indicates an unauthorized request.
    if (response.statusCode == 401) {
      // Remove this interceptor from Dio to avoid recursion.
      dio.interceptors
          .removeWhere((element) => element is AuthorizationInterceptor);

      // Reject the response with a custom DioException.
      return handler.reject(
        DioException(
          response: response,
          error: 'Bearer Token Expired',
          type: DioExceptionType.unknown,
          requestOptions: response.requestOptions,
        ),
      );
    }
    // Continue with the response if no issues are found.
    return handler.next(response);
  }
}
