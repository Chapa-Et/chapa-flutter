part of 'network_bloc.dart';

/// Enum representing the various types of network connections.
///
/// This enum helps categorize the current network connectivity status of the device.
///
/// - [wifi]: Represents a Wi-Fi connection.
enum ConnectionType {
  /// Wi-Fi connection type.
  wifi,

  /// Mobile network connection type.
  mobile,

  /// No network connection (offline).
  none,
}

/// Abstract class representing the state of the network.
abstract class NetworkState {}

/// Initial state of the network, typically used when the network state hasn't been initialized yet.
class NetworkInitial extends NetworkState {}

/// State representing a network loading process, such as waiting for a connection.
class NetworkLoading extends NetworkState {
  // The state does not need any additional data, it simply represents loading.
}

/// State representing a successful network operation or connection.
class NetworkSuccess extends NetworkState {
  // This state can be extended to hold data on a successful network connection if needed in the future.
}

/// State representing a network failure, such as when the device is offline or there's an error in the network request.
class NetworkFailure extends NetworkState {
  // This state can be extended to hold an error message or more details about the failure.
}
