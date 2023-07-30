part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object?> get props => [];
}

class LoadMatchs extends MatchEvent{
  String userId;
  LoadMatchs({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class DeleteLikedMeUser extends MatchEvent{
  String userId;
  String likedMeUserId;
  DeleteLikedMeUser({required this.userId, required this.likedMeUserId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, likedMeUserId];
}

class OpenChat extends MatchEvent{
  Message message;
  OpenChat({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class LikeLikedMeUser extends MatchEvent{
  final String userId;
  final User likedMeUser;

  LikeLikedMeUser({required this.userId, required this.likedMeUser});

}

class UpdateMatches extends MatchEvent{
  final List<UserMatch>? matchedUsers;
  final List<Like>? likedMeUsers;
  UpdateMatches({required this.matchedUsers, required this.likedMeUsers});

  @override
  // TODO: implement props
  List<Object?> get props => [matchedUsers, likedMeUsers];
}

class UpdateLikes extends MatchEvent{
  final List<User>? users;
  UpdateLikes({required this.users});

  @override
  // TODO: implement props
  List<Object?> get props => [users];
}