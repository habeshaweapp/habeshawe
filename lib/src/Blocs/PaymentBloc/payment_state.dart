part of 'payment_bloc.dart';

enum SubscribtionStatus{initial, notSubscribed, subscribedMonthly, subscribedYearly, subscribed6Months, ET_USER}
enum Boosts{boosts1, boosts5, boosts10}
enum SuperLikes{superlikes3, superlikes15,superlikes30}

class PaymentState extends Equatable {
  const PaymentState({
    this.subscribtionStatus = SubscribtionStatus.initial,
    this.productDetails = const [],
    this.purchaseDetails,
    this.boosts,
    this.superLikes
  });

  final SubscribtionStatus subscribtionStatus;
  final List<ProductDetails> productDetails;
  final List<PurchaseDetails>? purchaseDetails;
  final int? boosts;
  final int? superLikes;


  PaymentState copyWith({
    SubscribtionStatus? subscribtionStatus,
    List<ProductDetails>? productDetails,
    List<PurchaseDetails>? purchaseDetails,
    int? boosts,
    int? superLikes

  }){
    return PaymentState(
      productDetails: productDetails ?? this.productDetails,
      subscribtionStatus: subscribtionStatus ?? this.subscribtionStatus,
      purchaseDetails: purchaseDetails ?? this.purchaseDetails,
      boosts: boosts ?? this.boosts,
      superLikes: superLikes ?? this.superLikes
    );
  }
  
  @override
  List<Object?> get props => [subscribtionStatus, productDetails, purchaseDetails,boosts,superLikes];
}

class PaymentInitial extends PaymentState {}

// class NotSubscribed extends PaymentState{}

// class Subscribed extends PaymentState{
//   String subscribtionType;

//   Subscribed({required this.subscribtionType});
// }
// class SubscribtionState extends PaymentState{
//   List<ProductDetails>? productDetails;
//   String? subscribtionType;

//   SubscribtionState({this.productDetails, this.subscribtionType});

//   SubscribtionState copyWith({
//   List<ProductDetails>? productDetails,
//   String? subscribtionType
//   }){
//     return SubscribtionState(
//       productDetails: productDetails ?? this.productDetails,
//       subscribtionType: subscribtionType ?? this.subscribtionType,
//     );
//   }
  
// }
