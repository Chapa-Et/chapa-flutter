import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  StreamSubscription? subscription;
  NetworkBloc() : super(NetworkInitial()) {
    on<OnNetworkConnected>((event, emit) {
      emit(NetworkSuccess());
    });
    on<OnNetworkNotConnected>((event, emit) {
      emit(NetworkFailure());
    });
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.ethernet ||
          connectivityResult == ConnectivityResult.vpn) {
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
