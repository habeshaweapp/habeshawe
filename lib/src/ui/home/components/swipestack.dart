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
        return current is SwipeLoaded || previous is SwipeLoading;
      } ,
      builder: (context, state) {
        if(state is SwipeLoading){
          return Center(child: CircularProgressIndicator());
        }

        if(state is SwipeLoaded){
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
                  final itemIndex = swipeProperty.index % state.users.length;
                  return UserCard().userDrag(MediaQuery.of(context).size, state.users[itemIndex], context);
                })
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
                        if(index == 0){ _controller.rewind();}
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