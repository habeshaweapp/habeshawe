import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lomi/src/Data/Repository/Payment/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _paymentRepository;
  StreamSubscription? _purchaseSubscription;

  PaymentBloc({
    required PaymentRepository paymentRepository
  }): _paymentRepository = paymentRepository,
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

  FutureOr<void> _purchaseUpdated(PurchaseUpdated event, Emitter<PaymentState> emit)  {
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
            }
          }
        }
      }
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
