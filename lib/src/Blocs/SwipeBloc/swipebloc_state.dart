part of 'swipebloc_bloc.dart';

abstract class SwipeState extends Equatable {
   SwipeState();
  
  @override
  List<Object> get props => [];
}

//class SwipeblocInitial extends SwipeState {}

class SwipeLoading extends SwipeState{}

//class SwipeProcessingLeftOrRight extends SwipeState{}

class SwipeLoaded extends SwipeState{
  final List<User> users;
   SwipeLoaded({required this.users});

   //SwipeLoaded copyWith({})

  @override
  List<Object> get props => [users];
}

class SwipeError extends SwipeState {}

class ItsaMatch extends SwipeState{
  final User user;
  ItsaMatch({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}
