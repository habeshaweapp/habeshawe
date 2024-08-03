part of 'update_wall_bloc.dart';

class UpdateWallEvent extends Equatable {
  const UpdateWallEvent();

  @override
  List<Object> get props => [];
}
enum Shuts{update,fake}
class ShutDownEvent extends UpdateWallEvent{
  final Shuts shut;
  const ShutDownEvent({required this.shut});

  @override
  // TODO: implement props
  List<Object> get props => [shut];
}

class CheckShutDown extends UpdateWallEvent{}