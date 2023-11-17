part of 'userpreference_bloc.dart';

enum UserPreferenceStatus{loading,loaded, error}


class UserPreferenceState extends Equatable{
  final UserPreference? userPreference;
  final UserPreferenceStatus userPreferenceStatus;

  const UserPreferenceState({ 
    this.userPreference, 
    this.userPreferenceStatus = UserPreferenceStatus.loading
    });

  UserPreferenceState copyWith({
    UserPreference? userPreference,
    UserPreferenceStatus? userPreferenceStatus,

  }){
    return UserPreferenceState(
      userPreference: userPreference?? this.userPreference,
      userPreferenceStatus: userPreferenceStatus??this.userPreferenceStatus
    );
  }



  @override
  // TODO: implement props
  List<Object?> get props => [userPreference,userPreferenceStatus];
}


