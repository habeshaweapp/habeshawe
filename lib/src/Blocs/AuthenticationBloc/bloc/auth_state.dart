part of 'auth_bloc.dart';

enum AuthStatus {unknown, authenticated, unauthenticated}


class AuthState extends Equatable {
  final AuthStatus status;
  final auth.User? user;
  final bool? newAccount;

  AuthState({
    required this.status,
    required this.user,
    required this.newAccount,
  });

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.newAccount,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated({
    required auth.User user,
    required bool newAccount
  }): this._(
    status: AuthStatus.authenticated,
    user:  user,
    newAccount: newAccount,
  );

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  
  @override
  List<Object?> get props => [status, user, newAccount];

  
}


