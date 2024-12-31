import 'dart:io';

abstract class NetworkResponse<T, U> {
  const NetworkResponse();
}

class Success<T> extends NetworkResponse<T, dynamic> {
  final T body;

  const Success({
    required this.body,
  });
}

class ApiError<U> extends NetworkResponse<dynamic, U> {
  final U error;
  final int code;

  const ApiError({
    required this.error,
    required this.code,
  });
}

class NetworkError extends NetworkResponse<dynamic, dynamic> {
  final IOException error;

  const NetworkError({
    required this.error,
  });
}

class UnknownError extends NetworkResponse<dynamic, dynamic> {
  final dynamic error;
  const UnknownError({
    required this.error,
  });
}
