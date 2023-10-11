import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/dataApi/explore_json.dart';
import 'package:lomi/src/dataApi/icons.dart';
import 'package:lomi/src/ui/home/components/appiniocard.dart';
import 'package:lomi/src/ui/home/components/swipestack.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';

import 'components/swipecard.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
   var tempUsers = explore_json;
  @override
  Widget build(BuildContext context) {
    return const SwipeCard();
   
    //const SwipeStack();
    
    // Column(
    //   children: [
    //     UserCard(),
        
    //   //  Container(
    //   //   height: 100,
    //   //   decoration: BoxDecoration(
    //   //     color: Colors.red
    //   //   ),
    //   //  )


    //   ],
      
    // );
    
  }

  Widget getfooter(){
   // var size = MediaQuery.of(context).size;
    return Container(
      //color: Colors.black,
      //width: size.width,
      //height: 120,
      //decoration: BoxDecoration(color: Colors.brown),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          List.generate(item_icons.length, (index) {
            return InkWell(
              onTap: (){
                if(index == 3){
                 // context.read<SwipeBloc>().add(SwipeRightEvent(user: user))
                }
              },
              child: Container(
                width: item_icons[index]['size'],
                height: item_icons[index]['size'],
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                    )
                  ]
                ),
            
                child: Center(
                  child: SvgPicture.asset(
                    item_icons[index]['icon'],
                    width: item_icons[index]['icon_size'],
                    
                    ),
                ),
            
              ),
            );

          }),
        ),
      ),

    );
  }
}

