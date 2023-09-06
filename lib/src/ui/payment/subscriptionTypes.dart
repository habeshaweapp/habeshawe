  import 'package:flutter/material.dart';
class SubscriptionType extends StatelessWidget{ 
    final BuildContext context;
    final String name;
    final String description;
    final String price;
    final bool isSelected;
    final VoidCallback onTap;
  const SubscriptionType({ required this.context, required this.name, required this.description, required this.price, required this.onTap, required this.isSelected});
    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
     // width: MediaQuery.of(context),
     // height: 100,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        ),
        color: isSelected? Colors.amber[300] :Colors.grey[200] ,
                    child: InkWell(
                      onTap: onTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          //horizontal: size.width * 0.04,
                         // vertical: size.width * 0.02
                        ),
                       
                        height: 90,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              
                              Text(name,
                              style: Theme.of(context).textTheme.titleLarge,
                              ),
                            
                              Text(description,
                              style: Theme.of(context).textTheme.bodySmall,
                              ),
                            
                              Text(price,
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
                              )
                            ]),
                        ),
                      ),
                    ),
                  ),
    );
  }
  }