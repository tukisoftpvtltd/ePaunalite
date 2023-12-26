// !Builds connection between event and state
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/controller/internet_event.dart';
import '/controller/internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? connectivitySubscription;

  // InternetBloc initializes itself and super is used to initialize Bloc (extended class)
  InternetBloc() : super(InternetInitialState()) {
    // This checks event and emits state
    on<InternetLostEvent>(((event, emit) => emit(InternetLostState())));
    on<InternetGainedEvent>(((event, emit) => emit(InternetGainedState())));

    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        add(InternetGainedEvent());
      } else {
        add(InternetLostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    //Closing Connectivity Subscription
    connectivitySubscription?.cancel();
    return super.close();
  }
}
