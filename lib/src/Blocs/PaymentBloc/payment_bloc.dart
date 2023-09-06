import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Data/Repository/Payment/payment_repository.dart';

import '../../Data/Repository/Database/database_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  final DatabaseRepository _databaseRepository;
  final AuthBloc _authBloc;
  StreamSubscription? _purchaseSubscription;

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

    _purchaseSubscription =  paymentRepository.purchaseStream().listen((List<PurchaseDetails> purchaseDetailsList) { 
        add(PurchaseUpdated(purchaseDetailsList: purchaseDetailsList));
    },onDone: (){
      _purchaseSubscription!.cancel();
    },onError: (Object error){

    });

  } 
  
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {}

  FutureOr<void> _purchaseUpdated(PurchaseUpdated event, Emitter<PaymentState> emit) async {
    final payment = await _databaseRepository.getUserPayment(userId: _authBloc.state.user?.uid, users: _authBloc.state.accountType!);
    if(payment.countryCode != 'ET' && payment.country != 'Ethiopia'){

    
    if(event.purchaseDetailsList.isEmpty){
      emit(NotSubscribed());
    }else{
      for(var purchase in event.purchaseDetailsList){
        if(purchase.status == PurchaseStatus.restored || purchase.status == PurchaseStatus.purchased){
          Map purchaseData = json.decode(purchase.verificationData.localVerificationData);
          if(purchaseData['acknowledged']){
            emit(Subscribed(subscribtionType: purchase.productID));

          }else{
            //consume
            if(Platform.isAndroid){ 
              //final InAppPurchaseAndroidPlatformAddition androidPlatformAddition = 
               _paymentRepository.consumePurchaseAndroid(purchase);
              emit(Subscribed(subscribtionType: purchase.productID));
            }

            if(purchase.pendingCompletePurchase){
              _paymentRepository.completePurchase(purchase);
              emit(Subscribed(subscribtionType: purchase.productID));
            
            _databaseRepository.updatePayment(userId: _authBloc.state.user!.uid,users: _authBloc.state.accountType!, purchaseData: purchaseData, paymentType: purchase.productID);
            }
          }
        }
      }
    }
    }else{
      emit(Subscribed(subscribtionType: 'ET-USER'));
    }
  }

  FutureOr<void> _subscribe(Subscribe event, Emitter<PaymentState> emit) {
    _paymentRepository.purchaseSubscription(event.product);
  }


  @override
  Future<void> close() async {
    // TODO: implement close
    _purchaseSubscription!.cancel();
    return super.close();
  }
}
