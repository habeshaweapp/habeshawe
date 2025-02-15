import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:version/version.dart';

part 'update_wall_event.dart';
part 'update_wall_state.dart';

class UpdateWallBloc extends Bloc<UpdateWallEvent, UpdateWallState> {
  final RemoteConfigService remoteConfigService = RemoteConfigService();
  Version currentVersion = Version(1, 0, 0);
  UpdateWallBloc() : super(UpdateWallInitial()) {
    on<ShutDownEvent>((event, emit) {
      // TODO: implement event handler
      emit(ShutDownThisApp(shutz: event.shut));
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
    if(Platform.isIOS ){
      shutBeforeVersion = remoteConfigService.iosVersionToStop();
    }
    Version shutBefore = Version.parse(shutBeforeVersion);
    if(currentVersion < shutBefore){
      add(ShutDownEvent(shut: Shuts.update));
    }else{
      emit(Helen());
    }
  }
}
