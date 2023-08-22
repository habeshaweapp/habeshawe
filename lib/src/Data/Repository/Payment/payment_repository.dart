import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class PaymentRepository{
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final List<ProductDetails> _products = <ProductDetails>[];

  //list of store products
  Set<String> _KIds = <String>{'monthly', 'yearly', '6monthly'};

  Future<List<ProductDetails>> getProducts() async{
    final isAvailable = await _inAppPurchase.isAvailable();
    if(isAvailable){
     final response = await _inAppPurchase.queryProductDetails(_KIds);
        
      _products.addAll(response.productDetails);
      return response.productDetails;
        
    }else{
    throw Exception('server not available');
    }
  }
Stream<List<PurchaseDetails>> purchaseStream(){
  final purchase = _inAppPurchase.purchaseStream;
  return purchase;
}

void purchaseSubscription(ProductDetails productDetails) async{
  await _inAppPurchase.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: productDetails));
}


  










  late StreamSubscription<List<PurchaseDetails>> _subscription;


//initialize purchase variables
  void initPurchase(){

  final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;

  _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    _listenToPurchaseUpdated(purchaseDetailsList);

  }, onDone: (){
    _subscription.cancel();
  }, onError: (Object error){
    //handle error here
  }
  );

  }
  
  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {}

 void consumePurchaseAndroid(PurchaseDetails purchase)async {
  final androidPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
  
  await androidPlatformAddition.consumePurchase(purchase);
 }

  void completePurchase(PurchaseDetails purchase) async {
    await _inAppPurchase.completePurchase(purchase);
  }


}