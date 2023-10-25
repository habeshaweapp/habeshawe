part of 'onboarding_bloc.dart';

abstract class OnboardingState extends Equatable {
  const OnboardingState();
  
  @override
  List<Object?> get props => [];
}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final User user;
  final List<XFile?>? selectedImages;
  const OnboardingLoaded({required this.user, this.selectedImages});

  OnboardingLoaded copyWith({
    User? user,
    List<XFile?>? selectedImages
  }){
    return OnboardingLoaded(
      user: user?? this.user,
      selectedImages: selectedImages?? this.selectedImages
      );
  }

  @override
  List<Object?> get props => [user, selectedImages];
}

