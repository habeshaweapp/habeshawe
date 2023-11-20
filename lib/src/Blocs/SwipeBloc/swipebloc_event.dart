part of 'swipebloc_bloc.dart';

abstract class SwipeEvent extends Equatable {
   SwipeEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsers extends SwipeEvent{
  final String userId;
  final Gender users;
   User? user;
   UserPreference? prefes;
   LoadUsers({required this.userId, required this.users,  this.user,  this.prefes });

  @override
  List<Object?> get props => [userId, users];
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
  final bool superLike; 
  
  SwipeRightEvent({ required this.user,required this.matchUser, this.superLike = false});
  
  @override
  // TODO: implement props
  List<Object?> get props => [user,matchUser, superLike];
}

class SwipeEnded extends SwipeEvent{
  final DateTime? completedTime;
  SwipeEnded({ this.completedTime});

  @override
  // TODO: implement props
  List<Object?> get props => [completedTime];
}

class BoostedLoaded extends SwipeEvent{
  final List<User> users;
  
   BoostedLoaded({required this.users});

  @override
  // TODO: implement props
  List<Object?> get props => [users];
}

class LoadUserAd extends SwipeEvent{
  final String userId;
  final Gender users;
  final LoadFor loadFor;
  final int limit;
   LoadUserAd({required this.userId, required this.users, required this.loadFor, required this.limit});

  @override
  List<Object?> get props => [userId, users,loadFor,limit];
}

class AdSwipeEnded extends SwipeEvent{
  final DateTime? completedTime;
  AdSwipeEnded({ this.completedTime});

  @override
  // TODO: implement props
  List<Object?> get props => [completedTime];
}

class BoostMe extends SwipeEvent{
 
  final User user;
  
   BoostMe({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
