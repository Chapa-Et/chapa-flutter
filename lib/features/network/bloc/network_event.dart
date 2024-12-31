part of 'network_bloc.dart';

class NetworkEvent {
  const NetworkEvent();
}

class OnNetworkConnected extends NetworkEvent {}

class OnNetworkNotConnected extends NetworkEvent {}
