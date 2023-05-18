part of 'userpreference_bloc.dart';

abstract class UserpreferenceState extends Equatable {
  const UserpreferenceState();
  
  @override
  List<Object> get props => [];
}

class UserpreferenceInitial extends UserpreferenceState {}

class UserPreferenceLoading extends UserpreferenceState{}

class UserPreferenceLoaded extends UserpreferenceState{
  final UserPreference userPreference;

  UserPreferenceLoaded({required this.userPreference});

  @override
  // TODO: implement props
  List<Object> get props => [userPreference];
}


