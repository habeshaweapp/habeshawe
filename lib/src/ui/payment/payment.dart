import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../Blocs/PaymentBloc/payment_bloc.dart';
import 'subscriptionTypes.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    

    List<Map<String, String>> subs =[
      {
        'name': '1',
        'description': 'Month',
        'price': '\$9.99'
      },

      {
        'name': '6',
        'description': 'Months',
        'price': '\$49.99'
      },

      {
        'name': '12',
        'description': 'Months',
        'price': '\$99.99'
      },
    ] ;
    return Container(
        color: Colors.transparent,
        child: Container(
          width: width * 0.9,
          height: height * 0.6,
         // color: Colors.transparent,
          child: Column(
            children: [
              Text(
                'Get HabeshaWe Premium',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
      
              ),
      
              SizedBox(height: 25,),
              Container(
                height: height * 0.25,
               // width: 600,
               //padding: EdgeInsets.all(-5),
               decoration: BoxDecoration(
                //color: Colors.amber
               ),
                child: PageView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    pageViewItem(context: context, image: 'assets/icons/likeIconPayment.png', title: 'View Profile', description: 'see profile of users who liked you and decide to like or ignore'),
                    pageViewItem(context: context, image: 'assets/icons/googleTransp.png', title: 'Chat With Match', description: 'get to know with your match today liked you and decide to like or ignore'),
                    pageViewItem(context: context, 
                    image: 'assets/icons/likeIconPayment.png', 
                    title: 'Become Kings', description: 'Increase you match by becoming king you will get as match as many matchs, your profile will be showed to normal users ')
                  ],
                ),
              ),
              SizedBox(height: 25,),

              SizedBox(
                height: 100,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(3, (index) => 
                    SubscriptionType(
                      context: context, 
                      name: subs[index]['name']!, 
                      description: subs[index]['description']!, 
                      price: subs[index]['price']!,
                      isSelected: selectedIndex == index,
                      onTap: (){
                        
                        setState(() {
                          selectedIndex = index;
                        });
                      }
                      )
                  ),
                ),
              ),
      
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
      
              //     productDetails(
              //       context: context,
              //       name: '1',
              //       description: 'Month',
              //       price: '\$9.99'
              //       ),
              //       productDetails(
              //         context: context, name: '6', description: 'months', price: '\$49.9'),
                    
              //       productDetails(context: context, name: '12', description: 'months', price: '\$99.99')
      
                  
              //   ],
              // ),
      
              SizedBox(height: 35,),
      
              SizedBox(
                width: width *0.5,
                child: ElevatedButton(
                  onPressed: (){
                    context.read<PaymentBloc>().add(Subscribe(product: ProductDetails(id: 'monthly',title: 'month',description: 'for e', price: '12', rawPrice: 34, currencyCode: 'USD')));
                  }, 
                  child: Text('CONTINUE'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
      
                  ),
                  ),
              )
            ],
          ),
          
        ),
      
    );
  }



  Column pageViewItem({required BuildContext context, required String image, required String title, required String description}) {
    return Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
    
                      Image.asset(image, height: 70,),
                      SizedBox(height: 30,),
                      Text(title,
                      
                      style: Theme.of(context).textTheme.bodyMedium ,
                      ),
                      Text(description
                       ,
                        style: Theme.of(context).textTheme.bodySmall ,
                        textAlign: TextAlign.center,
                        ),
                    ],
                  );
  }
}
