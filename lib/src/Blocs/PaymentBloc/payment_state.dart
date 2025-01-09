part of 'payment_bloc.dart';

enum SubscribtionStatus{notSubscribed, subscribedMonthly, subscribedYearly, subscribed6Months, ET_USER}
enum Boosts{boosts1, boosts5, boosts10}
enum SuperLikes{superlikes3, superlikes15,superlikes30}

class PaymentState extends Equatable {
  const PaymentState({
    this.subscribtionStatus = SubscribtionStatus.notSubscribed,
    this.productDetails = const [],
    this.purchaseDetails,
    this.boosts =0,
    this.superLikes=0,
    this.selectedProduct,
    this.boostedTime,
   this.countryCode = 'x'
  });

  final SubscribtionStatus subscribtionStatus;
  final List<ProductDetails> productDetails;
  final List<PurchaseDetails>? purchaseDetails;
  final int boosts;
  final int superLikes;
  final ProductDetails? selectedProduct;
  final DateTime? boostedTime;
  final String countryCode;


  PaymentState copyWith({
    SubscribtionStatus? subscribtionStatus,
    List<ProductDetails>? productDetails,
    List<PurchaseDetails>? purchaseDetails,
    int? boosts,
    int? superLikes,
    ProductDetails? selectedProduct,
    DateTime? boostedTime,
    bool? makeNull,
    String? countryCode

  }){
    return PaymentState(
      productDetails: productDetails ?? this.productDetails,
      subscribtionStatus: subscribtionStatus ?? this.subscribtionStatus,
      purchaseDetails: purchaseDetails ?? this.purchaseDetails,
      boosts: boosts ?? this.boosts,
      superLikes: superLikes ?? this.superLikes,
      selectedProduct: selectedProduct??this.selectedProduct,
      boostedTime: makeNull==true?null: boostedTime??  this.boostedTime,
      countryCode: countryCode??this.countryCode
    );
  }
  
  @override
  List<Object?> get props => [subscribtionStatus, productDetails, purchaseDetails,boosts,superLikes, selectedProduct,boostedTime, countryCode];
}

class PaymentInitial extends PaymentState {}

