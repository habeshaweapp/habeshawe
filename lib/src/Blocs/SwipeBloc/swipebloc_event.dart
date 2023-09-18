part of 'swipebloc_bloc.dart';

abstract class SwipeEvent extends Equatable {
   SwipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends SwipeEvent{
  final String userId;
  final Gender users;
   LoadUsers({required this.userId, required this.users});

  @override
  List<Object?> get props => [userId];
}

class UpdateHome extends SwipeEvent{
  final List<User>? users;
   UpdateHome({ this.users});

  @override
  List<Object?> get props => [users];
}

class SwipeLeftEvent extends SwipeEvent{
  final User user;
  final User passedUser;
  SwipeLeftEvent({ required this.passedUser, required this.user});
  
  @override
  // TODO: implement props
  List<Object?> get props => [passedUser, user];
}

class SwipeRightEvent extends SwipeEvent{
  final User user;
  final User matchUser;
  SwipeRightEvent({ required this.user,required this.matchUser});
  
  @override
  // TODO: implement props
  List<Object?> get props => [user,matchUser];
}

class SwipeEnded extends SwipeEvent{
  final DateTime completedTime;
  SwipeEnded({required this.completedTime});

  @override
  // TODO: implement props
  List<Object?> get props => [completedTime];
}