// import 'dart:developer';

// import 'package:appinio_swiper/appinio_swiper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:lomi/src/Blocs/blocs.dart';
// import 'package:lomi/src/ui/home/components/usercard.dart';
// import 'package:lomi/src/ui/home/components/userdrag.dart';

// import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
// import '../../../Blocs/ProfileBloc/profile_bloc.dart';
// import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
// import '../../../Blocs/ThemeCubit/theme_cubit.dart';
// import '../../../Blocs/UserPreference/userpreference_bloc.dart';
// import '../../../dataApi/icons.dart';

// class AppinioCard extends StatelessWidget {
//    AppinioCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = AppinioSwiperController();
//     return BlocBuilder<SwipeBloc, SwipeState>(
//       builder: (context, state) {
//         if(state is SwipeLoading){
//           return Center(child: CircularProgressIndicator());
//         }

//         if(state is SwipeCompleted){
//           final now =DateTime.now();
//           final remain  = now.difference(state.completedTime);
//           return Center(
//             child: Container(
//               height: 200,
//               child: Column(
//                 children: [
//                   Text('Thats it for today \ncome back Tomorrow!'),
//                   Text(
//                     '${remain.inHours}:${remain.inMinutes}:${remain.inSeconds} remains',
//                     style: Theme.of(context).textTheme.bodyLarge,

//                   ),

//                   SizedBox(height: 25,),
//                   ElevatedButton(
//                     onPressed: (){
//                       context.read<SwipeBloc>().add(LoadUsers(userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType!));
//                     }, 
//                     child: Text('get Matches')),
                  
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: FloatingActionButton(
//                       onPressed: (){
//                         showPrefesSheet(context: context);
//                       },
//                       child: Icon(Icons.settings),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           );
//         }

//         if(state is SwipeLoaded){
//           int leftCards = state.users.length;
//           int idx =0;
//           //var usrs =state.users.length >3? state.users.sublist(0+idx, 3+idx):state.users;

//           return 


//           Column(
//           children: [
//             Expanded(
//               child: Container(
//                // margin: const EdgeInsets.only(top: 5),
                
//                 //height: MediaQuery.of(context).size.height * 0.865,
//                 width: MediaQuery.of(context).size.width,
//                 //margin: EdgeInsets.only(left: 25),
               
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   //color: Colors.black
                  
//                   borderRadius: BorderRadius.circular(20)
//                 ),
            
//                 child: Stack(
//                   children: [
//                       SizedBox(
//               child: AppinioSwiper(
//                 backgroundCardsCount: 2,
//                 threshold: 100 ,
//                 maxAngle: 50,
//                 cardsSpacing: 1,
//                 swipeOptions: const AppinioSwipeOptions.all(),
//                 //AppinioSwipeOptions.only(left: true, right: true, top: true),
//                 unlimitedUnswipe: true,
//                 padding: EdgeInsets.all(0),
//                 controller: controller,

                
//                 onSwiping: (direction) {
//                   debugPrint(direction.toString());
//                 },
              
//                 onSwipe: (index, direction){
//                   log('the card is swiped to the : ' + direction.name);

//                   if(direction == AppinioSwiperDirection.right){
//                      context.read<SwipeBloc>().add(SwipeRightEvent(
//                       user: (context.read<ProfileBloc>().state as ProfileLoaded).user, 
//                       matchUser: state.users[index-1] ));
//                       idx++;
//                   }

//                   if(direction == AppinioSwiperDirection.left ){
//                      context.read<SwipeBloc>().add(SwipeLeftEvent(
//                       user: (context.read<ProfileBloc>().state as ProfileLoaded).user, 
//                       passedUser: state.users[index-1] ));
//                       leftCards --;
//                       idx++;
//                   }
//                   if(direction == AppinioSwiperDirection.top){
//                    var  likes = context.read<PaymentBloc>().state.superLikes;
//                    if(likes !=0){
//                      context.read<SwipeBloc>().add(SwipeRightEvent(
//                       user: (context.read<ProfileBloc>().state as ProfileLoaded).user, 
//                       matchUser: state.users[index-1],
//                       superLike: likes !=0
//                        ));
//                     context.read<PaymentBloc>().add(ConsumeSuperLike());
//                    }

//                    leftCards --;
                      
                      
//                   }
//                 },
//                 onEnd: (){
//                   context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));
//                 },
//                 unswipe: (unswiped){
//                   idx--;
//                   if(unswiped){
//                   log('SUCCESS: card was unswiped');
//                   }else{
//                   log("FAIL: no card left to unswipe");
//                   }
//                 },
//                 cardsCount: state.users.length,
            
//                 cardsBuilder: (context, index){
                  
//                   return UserCard(user: state.users[index]);

//                   //UserCard().userDrag(MediaQuery.of(context).size, state.users[index], context,null,index, leftCards, state.users.length);
                  
//                 }, 
                
//                 ),
//                    )
//                     ,
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                 color: Colors.transparent,
                
//                 child: Padding(
//               padding: const EdgeInsets.only(bottom: 2),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children:
//                 List.generate(item_icons.length, (index) {
//                   return InkWell(
//                     onTap: (){
//                       if(index == 1){controller.swipeLeft();
//                       }
//                       if(index == 3){controller.swipeRight();}
//                       if(index == 2){controller.swipeUp();
//                       }
//                       if(index == 0){controller.unswipe();}
//                       if(index == 4){ controller.unswipe();}
//                     },
//                     child: Container(
//                       width: item_icons[index]['size'],
//                       height: item_icons[index]['size'],
//                       decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.black12,
              
//                       ),
                  
//                       child: Center(
//               child:index !=1? SvgPicture.asset(
//                 item_icons[index]['icon'],
//                 width: item_icons[index]['icon_size'],
                
//                 ): Icon(Icons.close, color: Colors.red, size: 40,) ,
//                       ),
                  
//                     ),
//                   );
            
//                 }),
//               ),
//                 ),
            
//               ),
//                   )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 10,),

            
//           ],
//         );
//         }
//         else{
//           return Center(child: Text('something went wrong...'),);
//         }

        
//       },
//     );
//   }

//   void _swipe(int index, AppinioSwiperDirection direction) {
//     log('the card is swiped to the : ' + direction.name);
//     if(direction == AppinioSwiperDirection.right){
      
      
//     }
//   }

//   void _onEnd(BuildContext context) {
//     context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));
//     log("end reached!");
//   }

//   void _unSwipe(bool unswiped) {
    
//     if(unswiped){
//       log('SUCCESS: card was unswiped');
//     }else{
//       log("FAIL: no card left to unswipe");
//     }
//   }

//     void showPrefesSheet({required BuildContext context}) {
//     var state = context.read<UserpreferenceBloc>().state as UserPreferenceLoaded;
//     bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
//     showModalBottomSheet(
//       context: context, 
//       builder: (context){
//         return SizedBox(
//           //height: MediaQuery.of(context).size.height*0.4,
//           child: Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Column(
//               children: [
//                 SizedBox(height: 35,),
                  
//                 Card(
//                         elevation: 2,
//                         color: 
//                         isDark ? state.userPreference.discoverBy ==0?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==0? Colors.grey[400]: Colors.white,
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           margin: EdgeInsets.only(top: 5, bottom: 5,),
//                           decoration: BoxDecoration(
//                             //color: Colors.white,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
                              
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text('Discover By - HabeshaWe Logic'),
//                                   Switch(value: 
//                                   state.userPreference.discoverBy! == 0, 
//                                   onChanged: (value){
                                    
//                                     context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 0)));
//                                    // isThereChange = true;
//                                    Navigator.pop(context);
//                                   }),
//                                 ],
//                               ),
//                               Text('HabeshaWe algorithm gives you the best profiles who is rated beautiful Habesha profile around the world.',
//                           style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
//                       ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       SizedBox(height: 5,),
                  
                  
//               Card(
//                         elevation: 2,
//                         color: isDark ? state.userPreference.discoverBy ==1?  Colors.grey[800] :Colors.grey[900]  : state.userPreference.discoverBy ==1? Colors.grey[400]: Colors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                           child: Column(
//                             children: [
                        
//                               Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Discover By - Preference'),
//                                     Switch(value: state.userPreference.discoverBy! == 1, 
//                                     onChanged: (value){
                                      
//                                       context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 1)));
//                                      // isThereChange = true;
//                                      Navigator.pop(context);
//                                     }),
//                                   ],
//                                 ),
//                                 Text('You will get matches based on your preferences once in a day. your preference include all your profile information including age range that will probably will match with your choice and profile information.',
//                             style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
//                                             ),
                  
                          
                
//                             ],
//                           ),
//                         ),
//                       ),
//                     SizedBox(height: 5,),
                  
//                       Card(
//                         elevation: 2,
//                         color: isDark ? state.userPreference.discoverBy ==2?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==2? Colors.grey[400]: Colors.white,
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Text('Discover By - Nearby Matches'),
//                                     Switch(value: state.userPreference.discoverBy! == 2, 
//                                     onChanged: (value){
                                      
//                                       context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 2)));
//                                      // isThereChange = true;
//                                      Navigator.pop(context);
//                                     }),
//                                   ],
//                                 ),
//                                 Text('find peoples nearby within 2km away from you. this method is free you can use it anytime of the day with out time limit if there are peoples near you they will appear.',
//                             style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
//                                             ),
                             
//                             ],
//                           ),
//                         ),
//                       ),
                  
                  
                  
//               ],
//             ),
//           ),
//         );
//       }
//       );
//   }
// }