import 'dart:async';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class PaymentRepository{
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final List<ProductDetails> _products = <ProductDetails>[];

  //list of store products
  Set<String> _KIds = <String>{'premium','1boost', '5boosts', '10boosts','3superlikes','15superlikes', '30superlikes'};

  Set<String> products = <String>['android.test.purchased'].toSet();

  Future<List<ProductDetails>> getProducts() async{
    final isAvailable = await _inAppPurchase.isAvailable();
    if(isAvailable){
     final response = await _inAppPurchase.queryProductDetails(_KIds);
        
      //_products.addAll(response.productDetails);
      
      return response.productDetails;
        
    }else{
    throw Exception('server not available');
    }
  }
Stream<List<PurchaseDetails>> purchaseStream(){
  final purchase = _inAppPurchase.purchaseStream;
  return purchase;
}

Future<void> purchaseSubscription(ProductDetails productDetails) async{
  await _inAppPurchase.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: productDetails));
}

Future<void> purchaseConsumable(ProductDetails productDetails)async{
  try {
    
  await _inAppPurchase.buyConsumable(purchaseParam: PurchaseParam(productDetails: productDetails));
  } catch (e) {
    throw(Exception(e));
  }
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

 Future<void> consumePurchaseAndroid(PurchaseDetails purchase)async {
  final androidPlatformAddition = _inAppPurchase.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
  
  await androidPlatformAddition.consumePurchase(purchase);
 }

  Future<void> completePurchase(PurchaseDetails purchase) async {
    await _inAppPurchase.completePurchase(purchase);
  }


}