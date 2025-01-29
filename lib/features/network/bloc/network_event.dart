part of 'network_bloc.dart';

/// Base class for all network events.
///
/// Extend this class to define specific events related to network changes or actions.
class NetworkEvent {
  /// Constructor for the base [NetworkEvent] class.
  const NetworkEvent();
}

/// Event triggered when the device is connected to a network.
///
/// This event can be used to handle logic related to a successful connection
class OnNetworkConnected extends NetworkEvent {}

/// Event triggered when the device is not connected to any network.
///
/// This event can be used to handle logic for offline scenarios
class OnNetworkNotConnected extends NetworkEvent {}
