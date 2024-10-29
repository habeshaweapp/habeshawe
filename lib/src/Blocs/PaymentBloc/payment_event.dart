part of 'payment_bloc.dart';

class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object> get props => [];
}

class PaymentStarted extends PaymentEvent{
  final Payment payment;

  const PaymentStarted({required this.payment});

  @override
  // TODO: implement props
  List<Object> get props => [payment];
}

class PurchaseUpdated extends PaymentEvent{
  final List<PurchaseDetails> purchaseDetailsList;
  
  const PurchaseUpdated({required this.purchaseDetailsList});
}

class Subscribe extends PaymentEvent{
  ProductDetails product;
  Subscribe({required this.product});

  @override
  // TODO: implement props
  List<Object> get props => [product];
}

class BuyBoosts extends PaymentEvent{
  final ProductDetails product;

  const BuyBoosts({required this.product});

  @override
  // TODO: implement props
  List<Object> get props => [product];

}

class ConsumeBoost extends PaymentEvent{}

class BuySuperLikes extends PaymentEvent{
  final ProductDetails product;

  const BuySuperLikes({required this.product});

  @override
  // TODO: implement props
  List<Object> get props => [product];

}

class ConsumeSuperLike extends PaymentEvent{}

class BoostMe extends PaymentEvent{
 
  final User user;
  
   BoostMe({required this.user});

  @override
  // TODO: implement props
  List<Object> get props => [user];
}

class MakeNull extends PaymentEvent{}