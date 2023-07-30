part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent{
  final String userId;
  const LoadProfile({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}

class UpdateProfile extends ProfileEvent{
  final User user;
  const UpdateProfile({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UpdateProfileImages extends ProfileEvent{
  final User? user;
  final XFile image;

  UpdateProfileImages({required this.user, required this.image});

  @override
  // TODO: implement props
  List<Object?> get props => [user, image];
}

class EditUserProfile extends ProfileEvent{
  final User user;
  const EditUserProfile({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class VerifyMe extends ProfileEvent{
  final User user;
  final XFile image;
  final String? type;
  const VerifyMe({required this.user, required this.image,this.type});

  @override
  // TODO: implement props
  List<Object?> get props => [user, image, type];
}
