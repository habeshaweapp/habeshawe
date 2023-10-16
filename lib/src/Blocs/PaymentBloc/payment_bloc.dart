import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Repository/Payment/payment_repository.dart';

import '../../Data/Repository/Database/database_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _purchaseSubscription;

  List<String> subIds = ['monthly', 'yearly', '6months','premium'];
  List<String> boostsIds = ['1boost', '5boosts', '10boosts'];
  List<String> likesIds = ['3superlikes','15superlikes', '30superlikes'];

  PaymentBloc({
    required PaymentRepository paymentRepository,
    required DatabaseRepository databaseRepository,
    required AuthBloc authBloc,
  }): _paymentRepository = paymentRepository,
      _databaseRepository = databaseRepository,
      _authBloc = authBloc,
    super(PaymentInitial()) {
    on<PurchaseUpdated>(_purchaseUpdated);
    on<Subscribe>(_subscribe);
    on<PaymentStarted>(_onPaymentStarted);
    on<BuyBoosts>(_onBuyBoosts);
    on<BuySuperLikes>(_onBuySuperLikes);
    on<ConsumeBoost>(_onConsumeBoost);
    on<ConsumeSuperLike>(_onConsumeSuperLike);

    add(PaymentStarted());

    paymentRepository.purchaseStream().listen((List<PurchaseDetails> purchaseDetailsList) { 
        add(PurchaseUpdated(purchaseDetailsList: purchaseDetailsList));
    },onDone: (){
      _purchaseSubscription!.cancel();
    },onError: (Object error){

    });

  } 
  
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {}

  FutureOr<void> _purchaseUpdated(PurchaseUpdated event, Emitter<PaymentState> emit) async {
     final payment = await _databaseRepository.getUserPayment(userId: _authBloc.state.user?.uid, users: _authBloc.state.accountType!);
    // if(payment.countryCode != 'ET' && payment.country != 'Ethiopia'){

    
    if(event.purchaseDetailsList.isEmpty){
      //emit(NotSubscribed());
      emit(state.copyWith(subscribtionStatus: SubscribtionStatus.notSubscribed, purchaseDetails: event.purchaseDetailsList));
      _databaseRepository.updatePayment(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, purchaseData: {}, subscribtionStatus: SubscribtionStatus.notSubscribed.index, paymentType: SubscribtionStatus.notSubscribed.name,expireDate: payment.expireDate );
    }else{
      for(var purchase in event.purchaseDetailsList){
        if(purchase.status == PurchaseStatus.restored || purchase.status == PurchaseStatus.purchased){
         // if(subIds.contains(purchase.productID)){

          
          Map purchaseData = json.decode(purchase.verificationData.localVerificationData);
          if(subIds.contains(purchase.productID) && purchaseData['acknowledged']){
            //emit(Subscribed(subscribtionType: purchase.productID));
            SubscribtionStatus type = SubscribtionStatus.subscribedMonthly;
            if(purchase.productID == 'monthly' ){
              type = SubscribtionStatus.subscribedMonthly;
            }else if(purchase.productID == 'yearly'){
              type = SubscribtionStatus.subscribedYearly;
            }else{
              type = SubscribtionStatus.subscribed6Months;
            }

            int add = 0;
            if(payment.subscribtionStatus == SubscribtionStatus.subscribedMonthly.index){
              add = 30;
             }else if(payment.subscribtionStatus == SubscribtionStatus.subscribed6Months.index){
             add = 182;
            }else if(payment.subscribtionStatus == SubscribtionStatus.subscribedYearly.index){
             add = 366;
            }
            var expireDate = DateTime.fromMillisecondsSinceEpoch(payment.expireDate);

           var newExpireDate = expireDate.add(const Duration(minutes: 5));
            emit(state.copyWith(subscribtionStatus: type));
            _databaseRepository.updatePayment(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, purchaseData: purchaseData, subscribtionStatus: type.index, paymentType: type.name, expireDate: newExpireDate.millisecondsSinceEpoch );
           //}//end of subscribtion or nonConsumable

           if(purchase.pendingCompletePurchase){
              await _paymentRepository.completePurchase(purchase);
            }

           //for the consumables
            // if(boostsIds.contains(purchase.productID) || likesIds.contains(purchase.productID)){

           // }

          }else{
            //consume
            if(Platform.isAndroid){ 
              //final InAppPurchaseAndroidPlatformAddition androidPlatformAddition = 
              await _paymentRepository.consumePurchaseAndroid(purchase);
              //emit(Subscribed(subscribtionType: purchase.productID));
              
            }

            if(purchase.pendingCompletePurchase){
              await _paymentRepository.completePurchase(purchase);
              

              if(subIds.contains(purchase.productID)){
                SubscribtionStatus type = SubscribtionStatus.notSubscribed;
                if(purchase.productID == 'monthly' ){
                 type = SubscribtionStatus.subscribedMonthly;
                }else if(purchase.productID == 'yearly'){
                  type = SubscribtionStatus.subscribedYearly;
                }else{
                  type = SubscribtionStatus.subscribed6Months;
                }

                emit(state.copyWith(subscribtionStatus: type));

                int add = 0;
                if(payment.subscribtionStatus == SubscribtionStatus.subscribedMonthly.index){
                  add = 30;
                }else if(payment.subscribtionStatus == SubscribtionStatus.subscribed6Months.index){
                 add = 182;
                 }else if(payment.subscribtionStatus == SubscribtionStatus.subscribedYearly.index){
                  add = 366;
                 }
                var expireDate = DateTime.fromMillisecondsSinceEpoch(purchaseData['purchaseTime']);

                var newExpireDate = expireDate.add(const Duration(minutes: 5));

                _databaseRepository.updatePayment(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, purchaseData: purchaseData, 
                subscribtionStatus: type.index, paymentType: purchase.productID, expireDate: newExpireDate.millisecondsSinceEpoch );
              }
            //boosts complete
              if(boostsIds.contains(purchase.productID)){
                int boost = 0;
                if(purchase.productID == boostsIds[0]){
                  boost = 1;
                }else if(purchase.productID == boostsIds[1]){
                  boost = 5;
                }else if(purchase.productID == boostsIds[2]){
                  boost = 10;
                }

                emit(state.copyWith(boosts: state.boosts! + boost ));
                _databaseRepository.updateConsumable(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'boosts', value: state.boosts!);
              }

              //superlikes complete
              if(likesIds.contains(purchase.productID)){
                int likes = 0;
                if(purchase.productID == likesIds[0]){
                  likes = 3;
                }else if(purchase.productID == likesIds[1]){
                  likes = 15;
                }else if(purchase.productID == likesIds[2]){
                  likes = 30;
                }

                emit(state.copyWith(superLikes: state.superLikes??0 + likes ));
                _databaseRepository.updateConsumable(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'boosts', value: state.superLikes!);
              }


            }
          }
        }
      }
    }
    // }else{
    //  // emit(Subscribed(subscribtionType: 'ET-USER'));
    //  emit(state.copyWith(subscribtionStatus: SubscribtionStatus.ET_USER ));
    // }
  }

  FutureOr<void> _subscribe(Subscribe event, Emitter<PaymentState> emit) {
    _paymentRepository.purchaseSubscription(event.product);
  }


  @override
  Future<void> close() async {
    // TODO: implement close
    _purchaseSubscription?.cancel();
    return super.close();
  }

  FutureOr<void> _onPaymentStarted(PaymentStarted event, Emitter<PaymentState> emit)async {
    final payment = await _databaseRepository.getUserPayment(userId: _authBloc.state.user?.uid, users: _authBloc.state.accountType!);
    if(payment.countryCode != 'ET' && payment.country != 'Ethiopia'){
    final products = await _paymentRepository.getProducts();
    //emit(SubscribtionState(productDetails: products));
    var expireDate = DateTime.fromMillisecondsSinceEpoch(payment.expireDate, isUtc: true);
    int diff = DateTime.now().difference(expireDate).inMinutes;
    if(diff >=2){
      
      _databaseRepository.updatePayment(userId: _authBloc.state.user!.uid, users: _authBloc.state.accountType!, purchaseData: {}, subscribtionStatus: SubscribtionStatus.notSubscribed.index, paymentType: SubscribtionStatus.notSubscribed.name, expireDate: payment.expireDate);

      await _paymentRepository.restorePurchase();
    }
    emit(state.copyWith(productDetails: products, subscribtionStatus: SubscribtionStatus.values[payment.subscribtionStatus], boosts: payment.boosts, superLikes: payment.superLikes ));
  }
  else{
    emit(state.copyWith(subscribtionStatus: SubscribtionStatus.ET_USER));

  }
}

  FutureOr<void> _onBuyBoosts(BuyBoosts event, Emitter<PaymentState> emit) async{
    try {
      
     await _paymentRepository.purchaseConsumable(event.product);
    //  int boost = 0;
    //  if(event.product.id == boostsIds[0]){
    //   boost = 1;
    //  }
    //  if(event.product.id == boostsIds[1]){
    //   boost = 5;
    //  }
    //  if(event.product.id == boostsIds[2]){
    //   boost = 10;
    //  }
     //_databaseRepository.updateConsumable(userId:_authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'boosts', value: boost);

     } catch (e) {
      debugPrint(e.toString());
      
    }

  }

  FutureOr<void> _onBuySuperLikes(BuySuperLikes event, Emitter<PaymentState> emit) async {
    await _paymentRepository.purchaseConsumable(event.product);

    // int likes = 0;
    //  if(event.product.id == likesIds[0]){
    //   likes = 3;
    //  }
    //  if(event.product.id == likesIds[1]){
    //   likes = 15;
    //  }
    //  if(event.product.id == likesIds[2]){
    //   likes = 30;
    //  }
    // _databaseRepository.updateConsumable(userId:_authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'superLikes', value: likes);

  }

  FutureOr<void> _onConsumeBoost(ConsumeBoost event, Emitter<PaymentState> emit) {
    _databaseRepository.updateConsumable(userId:_authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'boosts', value: state.boosts! -1);
  }

  FutureOr<void> _onConsumeSuperLike(ConsumeSuperLike event, Emitter<PaymentState> emit) {
        _databaseRepository.updateConsumable(userId:_authBloc.state.user!.uid, users: _authBloc.state.accountType!, field: 'superlikes', value:state.boosts! -1);

  }


  
}