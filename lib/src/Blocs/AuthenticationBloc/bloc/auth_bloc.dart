import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  StreamSubscription<auth.User?>? _userSubscription;
  final DatabaseRepository _databaseRepository;
  AuthBloc({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository
  }) : _authRepository = authRepository,
       _databaseRepository = databaseRepository,
  super(AuthState.unknown()) {

    _userSubscription = _authRepository.user.listen(
      (user) => add(
          
          AuthUserChanged(user: user)
        )
    );

    on<AuthUserChanged>(_authUserChanged);
    on<LogInWithGoogle>(_onLogInWithGoogle);
    on<LogOut>(_onLogOut);
    on<DeleteAccount>(_onDeleteAccount);
    on<ActivityStatus>(_onActivityStatus);
    //on<SignUpCompeleted>(_onSignUpCompeleted);
  }


  @override
Future<void> close(){
  _userSubscription?.cancel();
  return super.close();
}


void _authUserChanged(AuthUserChanged event, Emitter<AuthState> emit) async{

  try {
  if(event.user != null ){
    Gender isUserAlreadyRegistered = await _databaseRepository.isUserAlreadyRegistered(event.user!.uid);
    bool isCompleted;
    if(isUserAlreadyRegistered == Gender.nonExist){
      isCompleted = false;
    }else{
     isCompleted = await _databaseRepository.isCompleted(isUserAlreadyRegistered,event.user!.uid);
    }
    
    emit(AuthState.authenticated(user: event.user!,accountType: isUserAlreadyRegistered , isCompleted: isCompleted, firstTime: event.firstTime));

    // bool isRunning =await FlutterBackgroundService().isServiceRunning();
    // if( !isRunning){

    // }

    if(isCompleted){
      var isRunning =await FlutterBackgroundService().isRunning();
      var userId = event.user!.uid;
      //var isFirst = SharedPrefes.getFirstLogIn();

      if(!isRunning){
        await FlutterBackgroundService().startService();
        FlutterBackgroundService().invoke('user',
          {
            'userId': userId,
            'gender': isUserAlreadyRegistered.index,         
          }
        );

      }
    }
      
    //   if(isRunning){

    //     //if(isFirst == null || isFirst ==true){
       
    //     FlutterBackgroundService().invoke('user',
    //       {
    //         'userId': userId,
    //         'gender': isUserAlreadyRegistered.index,
    //         'isFirst': isFirst
    //       }
    //     );

    //    // }

    //   }else{
    //      FlutterBackgroundService().startService();
    //   }
    // }
    
  }else{
    emit(AuthState.unauthenticated());
  }
} on Exception catch (e) {
  // TODO
  print(e.toString());
}

}

FutureOr<void> _onLogOut(LogOut event, Emitter<AuthState> emit) async {
  
  await _databaseRepository.updateOnlinestatus(
                            userId: state.user!.uid, 
                            gender: state.accountType!, 
                            online: false
                             );
  emit(const AuthState.unauthenticated());
  await _authRepository.signOut();
  // emit(const AuthState.unauthenticated());
  await HydratedBloc.storage.clear();
  SharedPrefes.clear();
  FlutterBackgroundService().invoke('stopService');
  NotificationService.onClickNotification.close();

  //FlutterBackgroundService().sendData({'action':'stopService'});

}

Future<void> _onLogInWithGoogle(LogInWithGoogle event, Emitter<AuthState> emit) async{
 
}


  FutureOr<void> _onDeleteAccount(DeleteAccount event, Emitter<AuthState> emit)async {
    try {
      var st = state;
      emit(const AuthState.unauthenticated());
       
      await _databaseRepository.deleteAccount(userId: st.user!.uid, email:st.user!.email,displayName:st.user!.displayName, gender: st.accountType!, reason: event.reason).then((value) => 
       _authRepository.deleteAccount()
      );
      
      
    } catch (e) {
      print(e);
    }
  }

 

  FutureOr<void> _onActivityStatus(ActivityStatus event, Emitter<AuthState> emit) {
    _databaseRepository.updateOnlinestatus(userId: state.user!.uid, gender: state.accountType!, online: event.active);

  }

}

