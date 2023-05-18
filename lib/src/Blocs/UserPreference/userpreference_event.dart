part of 'userpreference_bloc.dart';

abstract class UserpreferenceEvent extends Equatable {
  const UserpreferenceEvent();

  @override
  List<Object> get props => [];
}

class LoadUserPreference extends UserpreferenceEvent{
  final String userId;
  
  LoadUserPreference({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserPreference extends UserpreferenceEvent{
  final UserPreference preference;
  
  UpdateUserPreference({required this.preference});

  @override
  // TODO: implement props
  List<Object> get props => [preference];
}
class EditUserPreference extends UserpreferenceEvent{
  final UserPreference preference;
  const EditUserPreference({required this.preference});

  @override
  // TODO: implement props
  List<Object> get props => [preference];
}
