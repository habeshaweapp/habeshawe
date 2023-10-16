import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  StreamSubscription? _subscription;
  InternetBloc() : super(InternetInitial()){
    on<ConnectionChanged>(_onConnectionChanged);

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      add(ConnectionChanged(result: result));
      
     });
  }

  void _onConnectionChanged(ConnectionChanged event, Emitter<InternetState> emit) {
    if(event.result == ConnectivityResult.none){
      emit(const InternetStatus(isConnected: false));
    }else{
      emit(const InternetStatus(isConnected: true));
    }
  }
  
  @override
  Future<void> close() {
    // TODO: implement close
    _subscription?.cancel();
    return super.close();
  }
}
