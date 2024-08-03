part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserChanged extends AuthEvent{
  final auth.User? user;
  final bool? firstTime;

  const AuthUserChanged({
    required this.user,
    this.firstTime =false
  });

  @override
  List<Object?> get props => [user];

}

class LogInWithGoogle extends AuthEvent{}

class LogOut extends AuthEvent{}

class DeleteAccount extends AuthEvent{
  final String reason;
  const DeleteAccount({required this.reason});

  @override
  // TODO: implement props
  List<Object?> get props => [reason];
}

class SignUpCompeleted extends AuthEvent{}

class ActivityStatus extends AuthEvent{
  final bool active;
  const ActivityStatus({required this.active});

  @override
  // TODO: implement props
  List<Object?> get props => [active];
}