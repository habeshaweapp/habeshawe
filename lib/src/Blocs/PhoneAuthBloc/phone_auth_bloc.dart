import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';

part 'phone_auth_event.dart';
part 'phone_auth_state.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final AuthRepository _authRepository;
  PhoneAuthBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository,
   super(PhoneAuthInitial()) {

    on<SendOtpToPhone>(_onSendOtp);
    on<VerifySentOtp>(_onVerifyOtp);

    //when the firebase sends the code to the user's phone, this event will be fired
    on<OnPhoneOtpSent>((event, emit) => 
      emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId))
    ,);

    //when any error occurs while sending otp to the users phone this event will be fired
    on<OnPhoneAuthError>(
      (event, emit) => emit(PhoneAuthError(error: event.error)) ,
      );

    on<OnPhoneAuthVerificationComplete>(_loginWithCredentials);

  }

  FutureOr<void> _onSendOtp(SendOtpToPhone event, Emitter<PhoneAuthState> emit) async{
    emit(PhoneAuthLoading());

    try {
      await _authRepository.verifyPhone(
        phoneNumber: event.phoneNumber, 
        
        verificationCompleted: (PhoneAuthCredential credential) async{
          //on[verificationComplete], we will get the credential from the firebase and will send it ot the 
          //[OnPhoneAuthVerificationCompleteEvent] event to be handled by the bloc and then will emit the [phoneAuthVerified] state after successful login

          add(OnPhoneAuthVerificationComplete(credential: credential));

        } , 
        verificationFailed: (FirebaseAuthException e){
          //on [verificationFailed], we will get the exception from the firebase and will send it to the [OnPhoneAuthError] event to be handled by the bloc
          add(OnPhoneAuthError(error: e.code));

        }, 
        
        codeSent: (String verificationId, int? resendToken) {
          //On [codeSent], we will get the verificationId and the resendToken  from the firebase and will send it ot he [OnPhoneOtpSent] event to be handled by the bloc and then will emit the
          // [OnPhoneOtpSent] event after receiving the code from the users phone

          add(OnPhoneOtpSent(verificationId: verificationId, token: resendToken));
        }, 
        
        codeAutoRetrievalTimeout: (String verificationId) {},
        );
    }catch(e){

      emit(PhoneAuthError(error: e.toString()));

    }
  }

  FutureOr<void> _onVerifyOtp(VerifySentOtp event, Emitter<PhoneAuthState> emit) async{
    try {
      emit(PhoneAuthLoading());
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId, 
        smsCode: event.otpCode);

      add(OnPhoneAuthVerificationComplete(credential: credential));

    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }

  FutureOr<void> _loginWithCredentials(OnPhoneAuthVerificationComplete event,
                Emitter<PhoneAuthState> emit
  
  ) async{
    try {
      await _authRepository.signInWithCredential(event.credential).then((user){
        if(user.user != null){
          emit(PhoneAuthVerified());
        }
      });
    } catch (e) {
      emit(PhoneAuthError(error: e.toString()));
    }
  }
}
