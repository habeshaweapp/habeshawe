  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';

import '../../Data/Models/enums.dart';
class SubscriptionType extends StatelessWidget{ 
    final BuildContext context;
    final String name;
    final String description;
    final String price;
    final bool isSelected;
    final VoidCallback onTap;
    final Color bgColor;
    final double rawPrice;
    final PaymentUi paymentUi;
  const SubscriptionType({ required this.context, required this.name, required this.description, required this.price, required this.bgColor, required this.onTap, required this.isSelected, required this.rawPrice, required this.paymentUi });
    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;

    var eachPrice = rawPrice.toString();
    var subTitle = '';
    var subDescrib = '';

    if(paymentUi == PaymentUi.boosts || paymentUi == PaymentUi.superlikes){
       eachPrice = (rawPrice/int.parse(description.replaceAll(RegExp(r'[^0-9]'), '')) ).toStringAsFixed(2);
    }
    if(paymentUi == PaymentUi.subscription){
      if(rawPrice == 9.99 || rawPrice <25 ){
        subTitle = '1';
        subDescrib = 'Month';
        
      }else if(rawPrice == 99.99 || rawPrice >80  ){
        subTitle = '1';
        subDescrib = 'Year';

      }else if(rawPrice == 49.99 || (rawPrice > 35 && rawPrice < 70 )){
        subTitle = '6';
        subDescrib = 'Months';
      }
      
    }
    if(paymentUi == PaymentUi.subscription && context.read<PaymentBloc>().state.subscribtionStatus !=SubscribtionStatus.notSubscribed){
      return const SizedBox();
    }
    return Expanded(
      child: SizedBox(
       // width: MediaQuery.of(context),
       // height: 100,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 130.h,
            //width: 96.w,
            //(MediaQuery.of(context).size.width -50) * 0.304,
            padding: EdgeInsets.only(
              //horizontal: size.width * 0.04,
              top: 20.h
            ),
            decoration: BoxDecoration(
              border: isSelected? Border.all(width: 3, color: bgColor ):Border.all(width: 0.3, color: Colors.grey ),
              
    
            color:isDark? isSelected?Colors.grey[900]: Color.fromARGB(255, 56, 55, 55) : isSelected? Colors.white :Colors.grey[200] ,
            ),
           
            //height: 90,
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Column(
                children: [
                  
                  Text(paymentUi == PaymentUi.subscription?subTitle: description.replaceAll(RegExp(r'[^0-9]'), ''),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: isSelected? bgColor: Colors.grey),
                  ),
                
                  Text(paymentUi == PaymentUi.subscription?subDescrib: description.replaceAll(RegExp(r"\d"), ""),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isSelected? bgColor: Colors.grey, fontSize: 10.5.sp),
                  ),
                  SizedBox(height: 16.h,),
                
                  Text('${price[0]}$eachPrice',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: isSelected? bgColor: Colors.grey, fontSize: 17.sp),
                  ),
                  paymentUi == PaymentUi.subscription?SizedBox():
                  Text('/each', style: TextStyle(fontSize: 9.sp, color: Colors.grey),)
                  
                ]),
            ),
          ),
        ),
      ),
    );
  }
  }