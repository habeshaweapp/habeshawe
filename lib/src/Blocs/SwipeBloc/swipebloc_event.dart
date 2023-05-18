part of 'swipebloc_bloc.dart';

abstract class SwipeEvent extends Equatable {
   SwipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends SwipeEvent{
  final String userId;
   LoadUsers({required this.userId});

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
  final String userId;
  SwipeLeftEvent({ required this.userId, required this.user});
  
  @override
  // TODO: implement props
  List<Object?> get props => [userId, user];
}

class SwipeRightEvent extends SwipeEvent{
  final User user;
  final String userId;
  SwipeRightEvent({ required this.userId, required this.user});
  
  @override
  // TODO: implement props
  List<Object?> get props => [userId,user];
}