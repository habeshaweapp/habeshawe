  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
class SubscriptionType extends StatelessWidget{ 
    final BuildContext context;
    final String name;
    final String description;
    final String price;
    final bool isSelected;
    final VoidCallback onTap;
    final Color bgColor;
  const SubscriptionType({ required this.context, required this.name, required this.description, required this.price, required this.bgColor, required this.onTap, required this.isSelected});
    @override
    Widget build(BuildContext context) {
    // TODO: implement build
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return SizedBox(
     // width: MediaQuery.of(context),
     // height: 100,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 150,
          width: (MediaQuery.of(context).size.width -50) * 0.304,
          padding: EdgeInsets.only(
            //horizontal: size.width * 0.04,
            top: 25
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
                
                Text(description.replaceAll(RegExp(r'[^0-9]'), ''),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: isSelected? bgColor: Colors.grey),
                ),
              
                Text(description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isSelected? bgColor: Colors.grey),
                ),
                SizedBox(height: 20,),
              
                Text(price,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: isSelected? bgColor: Colors.grey, fontSize: 18),
                )
              ]),
          ),
        ),
      ),
    );
  }
  }