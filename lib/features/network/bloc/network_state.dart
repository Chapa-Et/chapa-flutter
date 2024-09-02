part of 'network_bloc.dart';

enum ConnectionType { wifi, mobile, none }

abstract class NetworkState {}

class NetworkInitial extends NetworkState {}

// ignore: must_be_immutable
class NetworkLoading extends NetworkState {}

class NetworkSuccess extends NetworkState {}

class NetworkFailure extends NetworkState {}
