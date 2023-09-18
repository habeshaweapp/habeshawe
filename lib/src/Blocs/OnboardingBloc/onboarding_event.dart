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

  UpdateUserImages({this.user, required this.image});

  @override
  List<Object?> get props => [user, image];
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
