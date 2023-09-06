part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatchs extends MatchEvent{
  String userId;
  Gender users;
  LoadMatchs({required this.userId, required this.users});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}



class OpenChat extends MatchEvent{
  Message message;
  Gender users;
  OpenChat({required this.message, required this.users});

  @override
  // TODO: implement props
  List<Object> get props => [message, users];
}



class UpdateMatches extends MatchEvent{
  final List<UserMatch>? matchedUsers;
  //final List<Like>? likedMeUsers;
  UpdateMatches({required this.matchedUsers});

  @override
  // TODO: implement props
  List<Object?> get props => [matchedUsers];
}

