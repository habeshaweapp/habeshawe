part of 'like_bloc.dart';

 class LikeEvent extends Equatable {
  const LikeEvent();

  @override
  List<Object> get props => [];
}

class LoadLikes extends LikeEvent{
  final String userId;
  final Gender users;
  const LoadLikes({required this.userId, required this.users});

  @override
  // TODO: implement props
  List<Object> get props => [userId];
}

class DeleteLikedMeUser extends LikeEvent{
  final String userId;
  final Gender users;
  final String likedMeUserId;
  const DeleteLikedMeUser({required this.userId, required this.users, required this.likedMeUserId});

  @override
  // TODO: implement props
  List<Object> get props => [userId, likedMeUserId];
}

class LikeLikedMeUser extends LikeEvent{
  final User user;
  final Like likedMeUser;
  final bool? isSuperLike;

 const LikeLikedMeUser({required this.user, required this.likedMeUser, this.isSuperLike = false});
 @override
  // TODO: implement props
  List<Object> get props => [user, likedMeUser];
}

class UpdateLikes extends LikeEvent{
  final List<Like> users;
  UpdateLikes({required this.users});

  @override
  // TODO: implement props
  List<Object> get props => [users];
}

class LoadMoreLikes extends LikeEvent{
  final String userId;
  final Gender gender;
  final Timestamp startAfter;

  const LoadMoreLikes({required this.userId, required this.gender, required this.startAfter});

  @override
  // TODO: implement props
  List<Object> get props => [userId, gender,startAfter];
}

