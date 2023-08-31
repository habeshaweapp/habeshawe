part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();
  
  @override
  List<Object> get props => [];
}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState{
  List<UserMatch> matchedUsers;
 // List<Like> likedMeUsers;
  MatchLoaded({required this.matchedUsers});

  @override
  // TODO: implement props
  List<Object> get props => [matchedUsers];
}


