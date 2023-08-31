part of 'like_bloc.dart';

class LikeState extends Equatable {
  const LikeState();
  
  @override
  List<Object> get props => [];
}

class LikeLoading extends LikeState {}

class LikeLoaded extends LikeState{
  final List<Like> likedMeUsers;
  const LikeLoaded({required this.likedMeUsers});

  @override
  // TODO: implement props
  List<Object> get props => [likedMeUsers];
}