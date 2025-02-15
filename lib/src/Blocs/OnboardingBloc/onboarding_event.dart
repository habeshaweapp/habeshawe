part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class StartOnBoarding extends OnboardingEvent{
  final User user;
  StartOnBoarding({required this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class UpdateUser extends OnboardingEvent{
  final User user;
  UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserImages extends OnboardingEvent{
  final User? user;
  final XFile image;
  final int index;

  UpdateUserImages({this.user, required this.image, required this.index});

  @override
  List<Object?> get props => [user, image,index];
}

class EditUser extends OnboardingEvent{
  final User user;

  EditUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class CompleteOnboarding extends OnboardingEvent{
  final Placemark placeMark;
  final User user;
  final bool isMocked;

  const CompleteOnboarding({required this.placeMark, required this.user, required this.isMocked});

  @override
  // TODO: implement props
  List<Object?> get props => [placeMark, user, isMocked];
}

class ImagesSelected extends OnboardingEvent{

  final List<XFile?> images;

  ImagesSelected({ required this.images});

  @override
  List<Object?> get props => [images];
}

class RemovePhoto extends OnboardingEvent{
  final String imageUrl;

  const RemovePhoto({required this.imageUrl});

  @override
  // TODO: implement props
  List<Object?> get props => [imageUrl];
}