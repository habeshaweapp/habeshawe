import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/BackgroundService/flutter_background_service.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';

import '../../Data/Models/enums.dart';
import '../../Data/Repository/Database/database_repository.dart';

part 'continuewith_state.dart';

class ContinuewithCubit extends Cubit<ContinuewithState> {
  AuthRepository _authRepository;
  DatabaseRepository _databaseRepository;
  ContinuewithCubit({
    required AuthRepository authRepository,
    required DatabaseRepository databaseRepository,
  }) : _authRepository = authRepository,
       _databaseRepository = databaseRepository,
   super(ContinuewithState.initial());

  Future<void> continueWithGoogle() async{
    emit(state.copyWith(status: ContinueStatus.submitting));
    try {
      emit(state.copyWith(status: ContinueStatus.submitting));
        final user = await _authRepository.logInWithGoogle();
        emit(state.copyWith(
          status: ContinueStatus.success,
          user: user,
        ));

      //backService(user!.uid);
      SharedPrefes.setFirstLogIn(true);

          
      }on Exception catch (e) {
        emit(state.copyWith(status: ContinueStatus.error));
        throw e;
        
      }

  }

  Future<void> continueWithTwitter() async{
    emit(state.copyWith(status: ContinueStatus.submitting));
    try{
      final user = await _authRepository.logInWithTwitter();

      emit(state.copyWith(
        status: ContinueStatus.success,
        user: user,
      ));

     // backService(user!.uid);
     SharedPrefes.setFirstLogIn(true);
      
    }on Exception catch(e){
      emit(state.copyWith(status: ContinueStatus.initial));
      print(e.toString());
    }
  }

//   void backService(String userId)async{
//     await initializeBackgroundService();
//     SharedPrefes.setFirstLogIn(true);
   
//     Gender isUserAlreadyRegistered = await _databaseRepository.isUserAlreadyRegistered(userId);
//     bool isCompleted;
//     if(isUserAlreadyRegistered == Gender.nonExist){
//       isCompleted = false;
//     }else{
//      isCompleted = true;
//      SharedPrefes.setGender(isUserAlreadyRegistered.index);
//      SharedPrefes.setUserId(userId);
//     }


//     if(isCompleted){
//      // var isRunning =await FlutterBackgroundService().isRunning();
//       var isRunning =await FlutterBackgroundService().isRunning();

//       if(!isRunning){
//       //isRunning =  await FlutterBackgroundService().startService();
//       await initializeBackgroundService();
//       isRunning =await FlutterBackgroundService().isRunning();
//       }
      
//       if(isRunning){

//         //if(isFirst == null || isFirst ==true){
//       try{
//         Future.delayed(Duration(seconds: 30),(){

//         FlutterBackgroundService().invoke('user',
//           {
//             'userId': userId,
//             'gender': isUserAlreadyRegistered.index,
//             'isFirst': true
//           }
//         );
//         }
//         );

//         // FlutterBackgroundService().sendData(
//         //   {
//         //     'action':'user',
//         //     'userId': userId,
//         //     'gender': isUserAlreadyRegistered.index,
//         //     'isFirst': true
//         //   }
//         // );

//        }catch(e){
//         print(e);
//        }

//        // }

//       }else{
//          //FlutterBackgroundService().startService();
//          await initializeBackgroundService();
//       }
//    // }

//   }
// }
}