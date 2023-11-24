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

class DeleteAccount extends AuthEvent{}

class SignUpCompeleted extends AuthEvent{}