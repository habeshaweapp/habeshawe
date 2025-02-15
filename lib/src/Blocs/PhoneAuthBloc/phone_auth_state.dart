part of 'phone_auth_bloc.dart';

abstract class PhoneAuthState extends Equatable {
  const PhoneAuthState();
  
  @override
  List<Object> get props => [];
}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthVerified extends PhoneAuthState{}

class PhoneAuthCodeSentSuccess extends PhoneAuthState{
  final String verificationId;
  
  const PhoneAuthCodeSentSuccess({
    required this.verificationId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [verificationId];
}

class PhoneAuthError extends PhoneAuthState{
  final String error;
  
  const PhoneAuthError({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

