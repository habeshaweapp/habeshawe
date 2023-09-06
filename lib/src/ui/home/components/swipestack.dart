import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/Blocs/ProfileBloc/profile_bloc.dart';
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
      buildWhen: (previous, current) {
        return current is SwipeLoaded && previous is SwipeLoading;
      } ,
      builder: (context, state) {
        if(state is SwipeLoading){
          return Center(child: CircularProgressIndicator());
        }

        if(state is SwipeLoaded){
          if(state.users.isEmpty ){
            return Container(
              child:   Center(
                child: Text('No Matches to show\n come back after 24 hours',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                ),),
            );
          }
          return 


          Column(
          children: [
            Expanded(
              child: Container(
                //margin: const EdgeInsets.only(top: 5),
                
                //height: MediaQuery.of(context).size.height * 0.79,
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
               // dragStartCurve: Curves.bounceInOut,
               stackClipBehaviour: Clip.none,
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
                  if(direction == SwipeDirection.left){
                    context.read<SwipeBloc>().add(SwipeLeftEvent(passedUser: state.users[index], user: (context.read<ProfileBloc>().state as ProfileLoaded ).user));

                  }
                  if(direction == SwipeDirection.right){
                    context.read<SwipeBloc>().add(SwipeRightEvent(user: (context.read<ProfileBloc>().state as ProfileLoaded ).user, matchUser: state.users[index]));
                  }
                },
               // horizontalSwipeThreshold: 0.8,
                //verticalSwipeThreshold: 0.8,
                builder: (context, swipeProperty) {
                  var tempUsers = state.users.length;
                  
                  final itemIndex = swipeProperty.index % state.users.length;
                  // final itemIndex = state.users.length - tempUsers;
                  // tempUsers --;
                   print('-------index------${swipeProperty.stackIndex }>>>>>>>${swipeProperty.index}');
                  // if(swipeProperty.index == state.users.length +1){
                  //   return  Container(child: Text('Thats all for today!'),);
                  // }
                  return UserCard().userDrag(MediaQuery.of(context).size, state.users[itemIndex], context);
                },
                overlayBuilder: (context, properties){
                  final opacity = min(properties.swipeProgress, 1.0);
                  final isRight = properties.direction == SwipeDirection.right;
                  var size = MediaQuery.of(context).size.width /1.5;
                  if(properties.direction == SwipeDirection.left){
                    return Opacity(
                      opacity: min(properties.swipeProgress, 1.0),
                      child: Transform.rotate(
                        angle:  2.17 /4,
                        child: Container(
                        margin:  EdgeInsets.only(left: size  ),
                        padding: const EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 5),
                          borderRadius: BorderRadius.circular(10)

                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('NOPE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 30),),
                        ),
                      ),
                        ),
                      );
                  }
                  return Opacity(
                    opacity: isRight ? opacity : 0,
                    child: Transform.rotate(
                      angle: - 2.17 / 4,
                      child: Container(
                        
                          margin: const EdgeInsets.all(50),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green,width: 5),
                            borderRadius: BorderRadius.circular(10)
                            
                    
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('LIKE', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 35),),
                          ),
                        ),
                    ),
                     );
                  }
                  
                  
               
                )
                      )
                    ),
            
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                  color: Colors.transparent,
                  
                  child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                  List.generate(item_icons.length, (index) {
                    return InkWell(
                      onTap: (){
                        if(index == 1){_controller.next(swipeDirection: SwipeDirection.left);
                        }
                        if(index == 3){_controller.next(swipeDirection: SwipeDirection.right);}
                        if(index == 2){_controller.next(swipeDirection: SwipeDirection.up);
                        }
                        if(index == 0){ _controller.rewind();
                        }
                        if(index == 4){ _controller.rewind();}
                      },
                      child: Container(
                        width: item_icons[index]['size'],
                        height: item_icons[index]['size'],
                        decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black12,
                
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
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            
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