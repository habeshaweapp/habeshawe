part of 'auth_bloc.dart';

enum AuthStatus {unknown, authenticated, unauthenticated}


class AuthState extends Equatable {
  final AuthStatus status;
  final auth.User? user;
  final Gender? accountType;
  final bool? isCompleted;

  AuthState({
    required this.status,
    required this.user,
    required this.accountType,
    required this.isCompleted
  });

  const AuthState._({
    this.status = AuthStatus.unknown,
    this.user,
    this.accountType,
    this.isCompleted
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated({
    required auth.User user,
    required Gender accountType,
    required bool isCompleted
  }): this._(
    status: AuthStatus.authenticated,
    user:  user,
    accountType: accountType,
    isCompleted: isCompleted
  );

  const AuthState.unauthenticated() : this._(status: AuthStatus.unauthenticated);
  
  @override
  List<Object?> get props => [status, user, accountType, isCompleted];


  factory AuthState.fromMap(Map<String, dynamic> map){
    return AuthState(
      status: map['status'], 
      user:  map['user'], 
      accountType: map['accountType'],
      isCompleted: map['isCompleted']
      );
  }

  Map<String, dynamic> toMap(){
    return {
      'status': status.index,
      'user': user != null? user!.uid : null,
      'accountType': accountType,
      'isCompleted': isCompleted
    };
  }

  String toJson() => jsonEncode(toMap());
 // json.encode(toMap(), toEncodable: (object) => toMap(),);

  factory AuthState.fromJson(String source) =>
    AuthState.fromMap(json.decode(source));
    
  
}


