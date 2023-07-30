part of 'phone_auth_bloc.dart';

abstract class PhoneAuthEvent extends Equatable {
  const PhoneAuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpToPhone extends PhoneAuthEvent{
  final String phoneNumber;
  const SendOtpToPhone({required this.phoneNumber});

  @override
  // TODO: implement props
  List<Object> get props => [phoneNumber];
}

class VerifySentOtp extends PhoneAuthEvent{
  final String otpCode;
  final String verificationId;

  const VerifySentOtp({required this.otpCode, required this.verificationId});

  @override
  // TODO: implement props
  List<Object> get props => [otpCode, verificationId];
}

class OnPhoneOtpSent extends PhoneAuthEvent{
  final String verificationId;
  final int? token;
  const OnPhoneOtpSent({
    required this.verificationId,
    required this.token
  });

  @override
  // TODO: implement props
  List<Object> get props => [verificationId];
}

class OnPhoneAuthError extends PhoneAuthEvent{
  final String error;
  
  const OnPhoneAuthError({required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnPhoneAuthVerificationComplete extends PhoneAuthEvent{
  final AuthCredential credential;

  const OnPhoneAuthVerificationComplete({required this.credential});

  @override
  // TODO: implement props
  List<Object> get props => [credential];
}