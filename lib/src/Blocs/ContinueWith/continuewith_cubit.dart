import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';

part 'continuewith_state.dart';

class ContinuewithCubit extends Cubit<ContinuewithState> {
  AuthRepository _authRepository;
  ContinuewithCubit({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
   super(ContinuewithState.initial());

  Future<void> continueWithGoogle() async{
    emit(state.copyWith(status: ContinueStatus.submitting));
    try {
        final user = await _authRepository.logInWithGoogle();
        emit(state.copyWith(
          status: ContinueStatus.success,
          user: user,
        ));
        
      } catch (e) {
        print(e.toString());
        
      }

  }
}
