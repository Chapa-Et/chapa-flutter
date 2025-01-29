import 'dart:io';

/// Represents the base class for all network responses.
///
/// This abstract class is designed to handle both successful responses
/// and different types of errors, providing a flexible way to manage
/// API communication results.
///
/// - [T]: The type of the successful response body.
/// - [U]: The type of the error response body.
abstract class NetworkResponse<T, U> {
  /// Base constructor for the `NetworkResponse` class.
  const NetworkResponse();
}

/// Represents a successful network response.
///
/// This class holds the response body returned from a successful API call.
///
/// - [T]: The type of the response body.
class Success<T> extends NetworkResponse<T, dynamic> {
  /// The response body from the successful API call.
  final T body;

  /// Constructs a `Success` response with the given body.
  const Success({
    required this.body,
  });
}

/// Represents an error response from an API.
///
/// This class is used for handling errors returned by the API,
/// typically with an error object and an associated HTTP status code.
///
/// - [U]: The type of the error response body.
class ApiError<U> extends NetworkResponse<dynamic, U> {
  /// The error object returned by the API.
  final U error;

  /// The HTTP status code associated with the error.
  final int code;

  /// Constructs an `ApiError` response with the given error object and status code.
  const ApiError({
    required this.error,
    required this.code,
  });
}

/// Represents a network-related error.
///
/// This class is used for handling network issues, such as connectivity problems.
///
/// - `error`: An `IOException` that provides details about the network issue.
class NetworkError extends NetworkResponse<dynamic, dynamic> {
  /// The `IOException` representing the network error.
  final IOException error;

  /// Constructs a `NetworkError` response with the given exception.
  const NetworkError({
    required this.error,
  });
}

/// Represents an unknown or unexpected error.
///
/// This class is used for errors that do not fall under specific categories,
/// such as unhandled exceptions or unexpected issues.
///
/// - `error`: A dynamic object providing details about the error.
class UnknownError extends NetworkResponse<dynamic, dynamic> {
  /// The unknown or unexpected error object.
  final dynamic error;

  /// Constructs an `UnknownError` response with the given error object.
  const UnknownError({
    required this.error,
  });
}
