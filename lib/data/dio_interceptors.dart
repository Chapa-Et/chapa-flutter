import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';

class AuthorizationInterceptor extends InterceptorsWrapper {
  final Dio dio;
  final String publicKey;
  AuthorizationInterceptor(this.dio, this.publicKey);

  @override
  Future onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      options.headers['Authorization'] = "Bearer $publicKey";
    } catch (e) {
      log('auth intercepter catched: $e');
    }
    return handler.next(options);
  }

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      dio.interceptors
          .removeWhere((element) => element is AuthorizationInterceptor);
      return handler.reject(
        DioException(
          response: response,
          error: 'Token Expired',
          type: DioExceptionType.unknown,
          requestOptions: response.requestOptions,
        ),
      );
    }
    return handler.next(response);
  }
}
