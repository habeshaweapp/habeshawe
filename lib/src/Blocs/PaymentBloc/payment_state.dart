part of 'payment_bloc.dart';

class PaymentState extends Equatable {
  const PaymentState();
  
  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class NotSubscribed extends PaymentState{}

class Subscribed extends PaymentState{
  String subscribtionType;

  Subscribed({required this.subscribtionType});
}
