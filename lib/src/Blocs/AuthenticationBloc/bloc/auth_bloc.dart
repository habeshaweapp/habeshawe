import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _userSubscription;
  AuthBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository,
  super(AuthState.unknown()) {

    _userSubscription = _authRepository.user.listen(
      (user) => add(
          
          AuthUserChanged(user: user)
        )
    );

    on<AuthUserChanged>(_authUserChanged);
    on<LogInWithGoogle>(_onLogInWithGoogle);
  }


  @override
Future<void> close(){
  _userSubscription?.cancel();
  return super.close();
}


void _authUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async{

  try {
  if(event.user != null ){
    bool isUserAlreadyRegistered = await DatabaseRepository().isUserAlreadyRegistered(event.user!.uid);
    emit(AuthState.authenticated(user: event.user!,newAccount: !isUserAlreadyRegistered ));
  }else{
    emit(AuthState.unauthenticated());
  }
} on Exception catch (e) {
  // TODO
  print(e.toString());
}

}

Future<void> _onLogInWithGoogle(LogInWithGoogle event, Emitter<AuthState> emit) async{
  try {
        final result = await _authRepository.logInWithGoogle();
        bool isUserAlreadyRegistered = await DatabaseRepository().isUserAlreadyRegistered(result!.uid);
        emit(AuthState.authenticated(user: result!, newAccount: !isUserAlreadyRegistered));
        
      }on Exception catch (e) {
        print(e.toString());
      }
}

  // @override
  // AuthState? fromJson(Map<String, dynamic> json) {
  //   // TODO: implement fromJson
  //   return AuthState.fromMap(json);
  // }

  // @override
  // Map<String, dynamic>? toJson(AuthState state) {
  //   // TODO: implement toJson
  //   return  state.toMap();
  //   //state.toJson();
  // }

  
}




