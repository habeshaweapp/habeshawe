part of 'payment_bloc.dart';

class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStarted extends PaymentEvent{}

class PurchaseUpdated extends PaymentEvent{
  final List<PurchaseDetails> purchaseDetailsList;
  
  const PurchaseUpdated({required this.purchaseDetailsList});
}

class Subscribe extends PaymentEvent{
  ProductDetails product;
  Subscribe({required this.product});
}
