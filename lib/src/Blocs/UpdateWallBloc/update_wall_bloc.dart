import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:version/version.dart';

part 'update_wall_event.dart';
part 'update_wall_state.dart';

class UpdateWallBloc extends Bloc<UpdateWallEvent, UpdateWallState> {
  final RemoteConfigService remoteConfigService = RemoteConfigService();
  Version currentVersion = Version(1, 0, 4);
  UpdateWallBloc() : super(UpdateWallInitial()) {
    on<ShutDownEvent>((event, emit) {
      // TODO: implement event handler
      emit(ShutDownThisApp());
    });
    on<CheckShutDown>(_onCheckShutDown);

    add(CheckShutDown());
    RemoteConfigService.shutDownStream.stream.listen((event) {
      if(event == 'shutDownBefore'){
        add(CheckShutDown());

      }
    });

  

  }

  FutureOr<void> _onCheckShutDown(CheckShutDown event, Emitter<UpdateWallState> emit) {
    String shutBeforeVersion = remoteConfigService.getAppVersionToStop().isNotEmpty?remoteConfigService.getAppVersionToStop():'0.0.0' ;
    Version shutBefore = Version.parse(shutBeforeVersion);
    if(currentVersion < shutBefore){
      add(ShutDownEvent());
    }else{
      emit(Ribka());
    }
  }
}
