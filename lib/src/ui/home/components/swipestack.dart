import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../dataApi/icons.dart';

class SwipeStack extends StatelessWidget {
  const SwipeStack({super.key});

  @override
  Widget build(BuildContext context) {
    final _controller = SwipableStackController();
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if(state is SwipeLoading){
          return Center(child: CircularProgressIndicator());
        }

        if(state is SwipeLoaded){
          return 


          Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 5),
              
              height: MediaQuery.of(context).size.height * 0.79,
              width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.only(left: 25),
             
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //color: Colors.black
                
                borderRadius: BorderRadius.circular(20)
              ),

              child: Stack(
                children: [
                  Container(
                    
                    child: SizedBox(
            child: SwipableStack(
              detectableSwipeDirections: const {
                SwipeDirection.left,
                SwipeDirection.right,
                SwipeDirection.down
              },
              controller: _controller,
              onSwipeCompleted: (index, direction) {
                if(kDebugMode){
                  print('$index, $direction');
                }
              },
              horizontalSwipeThreshold: 0.8,
              verticalSwipeThreshold: 0.8,
              builder: (context, swipeProperty) {
                final itemIndex = swipeProperty.index % state.users.length;
                return UserCard().userDrag(MediaQuery.of(context).size, state.users[itemIndex], context);
              })
          )
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),

            Container(
              color: Colors.transparent,
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

          if(index == 1){
            //_matchEngine!.currentItem?.nope();
            //controller.swipeLeft();
            
          }
          // if(index == 0){
          //   context.read<AuthRepository>().signOut();
          // }
          if(index == 3){
           // _matchEngine!.currentItem?.like();
           //controller.swipeRight();
          }

          if(index == 2){
            //_matchEngine!.currentItem?.superLike();
          //  controller.swipeUp();
          }
          

          if(index == 0){
            //context.read<AuthRepository>().signOut();
            //_matchEngine!.rewindMatch();
          }
          if(index == 4){
           // context.read<AuthRepository>().signOut();
            //_matchEngine!.rewindMatch();
           // controller.unswipe();
          }
        },
        child: Container(
          width: item_icons[index]['size'],
          height: item_icons[index]['size'],
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black12,
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.3),
            //     spreadRadius: 5,
            //     blurRadius: 10,
            //   )
            // ]
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

  ),
          ],
        );
        }
        else{
          return Center(child: Text('something went wrong...'),);
        }

        
      },
    );
  }
}