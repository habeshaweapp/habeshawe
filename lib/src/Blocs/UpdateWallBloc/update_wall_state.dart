part of 'update_wall_bloc.dart';

class UpdateWallState extends Equatable {
  const UpdateWallState();
  
  @override
  List<Object> get props => [];
}

class UpdateWallInitial extends UpdateWallState {}

class ShutDownThisApp extends UpdateWallState{
  final Shuts shutz;
  const ShutDownThisApp({required this.shutz});

  @override
  // TODO: implement props
  List<Object> get props => [shutz];

}

class Helen extends UpdateWallState{}

