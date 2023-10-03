import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../dataApi/icons.dart';

class SwipeStack extends StatelessWidget {
  const SwipeStack();

  @override
  Widget build(BuildContext context) {
    final _controller = SwipableStackController();
    return BlocBuilder<SwipeBloc, SwipeState>(
      buildWhen: (previous, current) {
        return (current is SwipeLoaded && previous is SwipeLoading) || current is SwipeCompleted;
      } ,
      builder: (context, state) {
        if(state is SwipeLoading){
          // BlocListener<UserpreferenceBloc, UserpreferenceState>(
          //   listener: (context, st){
          //     if(st is UserPreferenceLoaded){
          //       context.read<SwipeBloc>().add(LoadUsers(userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType!, prefes: st.userPreference));
          //     }

          //   });
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }

        if(state is SwipeCompleted){
          final now =DateTime.now();
          final remain  = now.difference(state.completedTime);
          return Center(
            child: Container(
              height: 200,
              child: Column(
                children: [
                  Text('Thats it for today \ncome back Tomorrow!'),
                  Text(
                    '${remain.inHours}:${remain.inMinutes}:${remain.inSeconds} remains',
                    style: Theme.of(context).textTheme.bodyLarge,

                  ),

                  SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: (){
                      context.read<SwipeBloc>().add(LoadUsers(userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType!));
                    }, 
                    child: Text('get Matches')),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      onPressed: (){
                        showPrefesSheet(context: context);
                      },
                      child: Icon(Icons.settings),
                    ),
                  )
                ],
              ),
            )
          );
        }


        if(state is SwipeLoaded){
          int noOfSwipedCards = 0;
          int totalCard = state.users.length;
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
                    noOfSwipedCards++;

                  }
                  if(direction == SwipeDirection.right){
                    context.read<SwipeBloc>().add(SwipeRightEvent(user: (context.read<ProfileBloc>().state as ProfileLoaded ).user, matchUser: state.users[index]));
                    noOfSwipedCards++;
                  }
                },
               // horizontalSwipeThreshold: 0.8,
                //verticalSwipeThreshold: 0.8,
                builder: (context, swipeProperty) {
                  var tempUsers = state.users.length;
                  
                  final itemIndex = swipeProperty.index % state.users.length;
                  // final itemIndex = state.users.length - tempUsers;

                  // tempUsers --;
                   print('-------index------${swipeProperty.index }>>>>>item index>>${itemIndex}>>>>   swipeProperty.index % state.users.length>>>>>${swipeProperty.index % state.users.length}');
                  // if(swipeProperty.index == state.users.length +1){
                  //   return  Container(child: Text('Thats all for today!'),);
                  // }
                  if(noOfSwipedCards == totalCard-1){
                    context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));
                   // _controller.dispose();
                    return Container();
                  }
                  return Container();

                //  return UserCard().userDrag(MediaQuery.of(context).size, state.users[itemIndex], context,_controller,);
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
  
  void showPrefesSheet({required BuildContext context}) {
    var state = context.read<UserpreferenceBloc>().state as UserPreferenceLoaded;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return SizedBox(
          //height: MediaQuery.of(context).size.height*0.4,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 35,),
                  
                Card(
                        elevation: 2,
                        color: 
                        isDark ? state.userPreference.discoverBy ==0?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==0? Colors.grey[400]: Colors.white,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(top: 5, bottom: 5,),
                          decoration: BoxDecoration(
                            //color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discover By - HabeshaWe Logic'),
                                  Switch(value: 
                                  state.userPreference.discoverBy! == 0, 
                                  onChanged: (value){
                                    
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 0)));
                                   // isThereChange = true;
                                   Navigator.pop(context);
                                  }),
                                ],
                              ),
                              Text('HabeshaWe algorithm gives you the best profiles who is rated beautiful Habesha profile around the world.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                      ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 5,),
                  
                  
              Card(
                        elevation: 2,
                        color: isDark ? state.userPreference.discoverBy ==1?  Colors.grey[800] :Colors.grey[900]  : state.userPreference.discoverBy ==1? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                        
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Preference'),
                                    Switch(value: state.userPreference.discoverBy! == 1, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 1)));
                                     // isThereChange = true;
                                     Navigator.pop(context);
                                    }),
                                  ],
                                ),
                                Text('You will get matches based on your preferences once in a day. your preference include all your profile information including age range that will probably will match with your choice and profile information.',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                                            ),
                  
                          
                
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 5,),
                  
                      Card(
                        elevation: 2,
                        color: isDark ? state.userPreference.discoverBy ==2?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==2? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Nearby Matches'),
                                    Switch(value: state.userPreference.discoverBy! == 2, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 2)));
                                     // isThereChange = true;
                                     Navigator.pop(context);
                                    }),
                                  ],
                                ),
                                Text('find peoples nearby within 2km away from you. this method is free you can use it anytime of the day with out time limit if there are peoples near you they will appear.',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                                            ),
                             
                            ],
                          ),
                        ),
                      ),
                  
                  
                  
              ],
            ),
          ),
        );
      }
      );
  }
}