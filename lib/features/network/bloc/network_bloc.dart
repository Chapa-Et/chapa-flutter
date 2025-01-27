import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'network_event.dart';
part 'network_state.dart';

/// A BLoC for managing network connectivity states.
///
/// The [NetworkBloc] listens to network connectivity changes using the
/// `connectivity_plus` package and emits corresponding states:
/// - [NetworkSuccess] when the device is connected.
/// - [NetworkFailure] when the device is disconnected.
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  /// A subscription to listen for connectivity changes.
  StreamSubscription? subscription;

  /// Creates an instance of [NetworkBloc] and initializes the connectivity listener.
  NetworkBloc() : super(NetworkInitial()) {
    on<OnNetworkConnected>((event, emit) {
      emit(NetworkSuccess());
    });
    on<OnNetworkNotConnected>((event, emit) {
      emit(NetworkFailure());
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.ethernet) ||
          connectivityResult.contains(ConnectivityResult.vpn)) {
        add(OnNetworkConnected());
      } else {
        add(OnNetworkNotConnected());
      }
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    return super.close();
  }
}
