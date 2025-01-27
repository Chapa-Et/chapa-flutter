import 'dart:io';
import 'package:chapasdk/domain/constants/url.dart';
import 'package:chapasdk/data/dio_interceptors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

/// A reusable HTTP client class using Dio for making API requests.
///
/// This class provides common HTTP methods (GET, POST, PATCH, etc.) and handles
/// connectivity checks, error management, and optional interceptor support.
class DioClient {
  /// [dio]: An optional Dio instance to override the default client.
  late Dio _dio;

  /// [baseUrl]: The base URL for all API requests. Defaults to [ChapaUrl.directChargeBaseUrl].
  final String? baseUrl;

  /// [interceptors]: List of interceptors to be added to the Dio client.
  final List<Interceptor>? interceptors;

  /// [connectivity]: An instance of [Connectivity] to check internet connection.
  final Connectivity connectivity;

  /// Creates a [DioClient] instance.
  DioClient(
    Dio? dio, {
    this.interceptors,
    this.baseUrl,
    required this.connectivity,
  }) {
    _dio = dio ?? Dio();
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () =>
        HttpClient()
          ..badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;

    _dio
      ..options = BaseOptions(
        baseUrl: ChapaUrl.directChargeBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        followRedirects: false,
      )
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json'};
    if (interceptors?.isNotEmpty ?? false) {
      _dio.interceptors.addAll(interceptors!);
    }
  }

  /// Adds an authorization interceptor to the Dio client.
  ///
  /// [publicKey]: The public key used for authentication.
  /// This method ensures that the interceptor is only added once.
  Future<void> addAuthorizationInterceptor(
    String publicKey,
  ) async {
    final hasAuthInterceptor =
        _dio.interceptors.any((element) => element is AuthorizationInterceptor);
    if (!hasAuthInterceptor) {
      _dio.interceptors.add(AuthorizationInterceptor(_dio, publicKey));
    }
  }

  /// Sends a GET request to the specified [uri].
  ///
  /// [uri]: The endpoint to which the GET request is sent.
  /// [queryParameters]: Optional query parameters.
  /// [options]: Optional request options.
  /// [cancelToken]: A token to cancel the request.
  /// [onReceiveProgress]: A callback for tracking response progress.
  ///
  /// Returns the response data.
  ///
  /// Throws Exceptions if response data is invalid,
  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a POST request to the specified [uri].
  ///
  /// [uri]: The endpoint to which the POST request is sent.
  /// [data]: The data to be sent in the request body.
  /// [queryParameters]: Optional query parameters.
  /// [options]: Optional request options.
  /// [cancelToken]: A token to cancel the request.
  /// [onSendProgress]: A callback for tracking upload progress.
  /// [onReceiveProgress]: A callback for tracking response progress.
  ///
  /// Returns the response data.
  /// Throws Exceptions if response data is invalid,
  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a PATCH request to the specified [uri].
  ///
  /// [uri]: The endpoint to which the PATCH request is sent.
  /// [data]: The data to be sent in the request body.
  /// [queryParameters]: Optional query parameters.
  /// [options]: Optional request options.
  /// [cancelToken]: A token to cancel the request.
  /// [onSendProgress]: A callback for tracking upload progress.
  /// [onReceiveProgress]: A callback for tracking response progress.
  ///
  /// Returns the response data.
  /// Throws Exceptions if response data is invalid,
  Future<dynamic> patch(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.patch(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a DELETE request to the specified [uri].
  ///
  /// [uri]: The endpoint to which the DELETE request is sent.
  /// [data]: The data to be sent in the request body.
  /// [queryParameters]: Optional query parameters.
  /// [options]: Optional request options.
  /// [cancelToken]: A token to cancel the request.
  /// [onSendProgress]: A callback for tracking upload progress.
  /// [onReceiveProgress]: A callback for tracking response progress.
  ///
  /// Returns the response data.
  /// Throws Exceptions if response data is invalid,
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  /// Sends a PUT request to the specified [uri].
  ///
  /// [uri]: The endpoint to which the PUT request is sent.
  /// [data]: The data to be sent in the request body.
  /// [queryParameters]: Optional query parameters.
  /// [options]: Optional request options.
  /// [cancelToken]: A token to cancel the request.
  /// [onSendProgress]: A callback for tracking upload progress.
  /// [onReceiveProgress]: A callback for tracking response progress.
  ///
  /// Returns the response data.
  /// Throws Exceptions if response data is invalid,
  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
