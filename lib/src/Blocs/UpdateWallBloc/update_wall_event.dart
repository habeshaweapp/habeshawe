part of 'update_wall_bloc.dart';

class UpdateWallEvent extends Equatable {
  const UpdateWallEvent();

  @override
  List<Object> get props => [];
}

class ShutDownEvent extends UpdateWallEvent{}

class CheckShutDown extends UpdateWallEvent{}