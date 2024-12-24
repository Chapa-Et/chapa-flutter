import 'dart:async';
import 'dart:io';
import 'package:chapasdk/domain/constants/enums.dart';
import 'package:chapasdk/data/dio_client.dart';
import 'package:chapasdk/data/model/response/api_error_response.dart';
import 'package:chapasdk/data/model/response/api_response.dart';
import 'package:chapasdk/data/model/network_response.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late DioClient dioClient;
  final Dio dio;
  final Connectivity connectivity;
  Map<String, dynamic> defaultParams = {};

  ApiClient({
    required this.dio,
    required this.connectivity,
  }) {
    dioClient = DioClient(dio, connectivity: connectivity);
  }
  Future<NetworkResponse> request<T, U>(
      {required RequestType requestType,
      bool requiresAuth = true,
      bool requiresDefaultParams = true,
      required String path,
      Map<String, dynamic>? queryParameters,
      Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      bool isBodyJsonToString = false,
      String jsonToStringBody = "",
      required T Function(Map<String, dynamic>) fromJsonSuccess,
      required U Function(Map<String, dynamic>, int) fromJsonError,
      required String publicKey}) async {
    try {
      if (requiresAuth) {
        await dioClient.addAuthorizationInterceptor(publicKey);
      }
      if (requiresDefaultParams && data != null) {
        data = Map<String, dynamic>.from(data);
        data.addAll(defaultParams);
      }

      Options? options;

      dynamic response;
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
      } catch (exeption) {
        return ApiError(error: e.response!.data, code: e.response!.statusCode!);
      }
    } catch (e) {
      return UnknownError(error: e);
    }
  }
}
