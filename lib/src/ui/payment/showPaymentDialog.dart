import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/ui/payment/payment.dart';

import '../../Data/Models/enums.dart';

showPaymentDialog({BuildContext? context, PaymentUi? paymentUi} ){
  return showDialog(
    context: context!,    
    builder: (ctx)=> AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      content: BlocProvider.value(
        value: context.read<PaymentBloc>(),
        child:  Payment(paymentUi: paymentUi!, ctx: context,),
    )));
}