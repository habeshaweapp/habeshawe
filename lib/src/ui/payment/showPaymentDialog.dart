import 'package:flutter/material.dart';
import 'package:lomi/src/ui/payment/payment.dart';

showPaymentDialog(BuildContext context){
  return showDialog(
    context: context, 
    builder: (context)=> AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      content: Payment(),
    ));
}