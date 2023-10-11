import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/ui/home/components/usercard.dart';
import 'package:lomi/src/ui/home/components/userdrag.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Data/Models/likes_model.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../dataApi/icons.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
      builder: (context, state) {
        if(state.swipeStatus == SwipeStatus.loading){
          return Center(child: CircularProgressIndicator(strokeWidth: 2,) );
        }
        if(state.swipeStatus == SwipeStatus.loaded){
          List<SwipeItem> _swipeItems = [];
          MatchEngine? _matchEngine;
          //state.users.forEach((user)
          for(var user in state.users)
           {
            _swipeItems.add(
              SwipeItem(
                content: user,
                likeAction: (){
                  //final user = (context.read<ProfileBloc>().state as ProfileLoaded).user;
                  SwipeRightEvent(     
                    user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                    matchUser: user
                    );
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));

                },
                nopeAction: (){
                  SwipeLeftEvent(
                    passedUser: user, 
                    user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                    );
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));
                },
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
             },
                superlikeAction: (){
                //   context.read<SwipeBloc>().add(
                // SwipeLeftEvent(
                //   userId: context.read<AuthBloc>().state.user!.uid,
                //   user: state.users[0]));
                }
              )
            );
          }

          _matchEngine = MatchEngine(swipeItems: _swipeItems);
          //_matchEngine!.cycleMatch();
          MatchEngine backUp = _matchEngine;
        return Column(
          children: [
            Expanded(
              child: Container(
                //margin: const EdgeInsets.only(top: 5),
                
               // height: MediaQuery.of(context).size.height * 0.79,
                width: MediaQuery.of(context).size.width,
                //margin: EdgeInsets.only(left: 25),
               
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  //color: Colors.black
                  
                  borderRadius: BorderRadius.circular(20)
                ),
            
                child: Stack(
                  children: [
                    SizedBox(
                      
                      child: SwipeCards(
                        matchEngine: _matchEngine, 
                        onStackFinished: (){
                          //_matchEngine = backUp;
                          //_matchEngine!.cycleMatch();
                          //_matchEngine!.dispose();
                          context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));
                        }, 
                        itemBuilder: (context, index){
                          print('>>>>.>>>>>>>>>>>>>>>>>>>${index}');
                          //return UserCard().userDrag(MediaQuery.of(context).size, _swipeItems[index].content, context);
                          return UserCard(user: state.users[index], matchEngine: _matchEngine!,);
                        },
                        leftSwipeAllowed: true,
                        rightSwipeAllowed: true,
                        upSwipeAllowed: true,
                        
            
                        likeTag: Container(
                          margin: const EdgeInsets.all(15),
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
            
                        nopeTag: Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red, width: 5),
                            borderRadius: BorderRadius.circular(10)
            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('NOPE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 35),),
                          ),
                        ),
            
                        superLikeTag: Container(
                          margin: const EdgeInsets.all(15),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 5),
                            borderRadius: BorderRadius.circular(10)
            
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('SUPER\nLIKE',textAlign: TextAlign.center, style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
                          ),
                        ),
                        ),
                    ),



                    Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                color: Colors.transparent,
                
                child: Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:
                List.generate(item_icons.length, (index) {
                  return InkWell(
                    onTap: (){
                      if(index == 1) _matchEngine!.currentItem?.nope();
                      if(index == 3){
                         _matchEngine!.currentItem?.like();
                      }
                      if(index == 2) _matchEngine!.currentItem?.superLike();
                      if(index == 0){
                        _matchEngine?.rewindMatch();
                        }
                      if(index == 4){ 
                        }
                    },
                    child: Container(
                      width: item_icons[index]['size'],
                      height: item_icons[index]['size'],
                      decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black12,
              
                      ),
                  
                      child: Center(
              child:index !=1? SvgPicture.asset(
                item_icons[index]['icon'],
                width: item_icons[index]['icon_size'],
                
                ): Icon(Icons.close, color: Colors.red, size: 30,) ,
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

  //           Container(
  //             color: Colors.transparent,
  //   //width: size.width,
  //   //height: 120,
  //   //decoration: BoxDecoration(color: Colors.brown),
    
  //   child: Padding(
  // padding: const EdgeInsets.only(bottom: 2),
  // child: Row(
  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //   children:
  //   List.generate(item_icons.length, (index) {
  //     return InkWell(
  //       onTap: (){

  //         if(index == 1){
  //           _matchEngine!.currentItem?.nope();
  //         }
  //         // if(index == 0){
  //         //   context.read<AuthRepository>().signOut();
  //         // }
  //         if(index == 3){
  //           _matchEngine!.currentItem?.like();
  //           context.read<SwipeBloc>().add(
  //               SwipeRightEvent(
  //                 user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
  //                matchUser: _swipeItems[index].content
  //                 ));
  //         }

  //         if(index == 3){
  //           _matchEngine!.currentItem?.superLike();
  //         }
          

  //         if(index == 0){
  //           //context.read<AuthRepository>().signOut();
  //           _matchEngine!.rewindMatch();
  //         }
  //         if(index == 4){
  //           context.read<AuthRepository>().signOut();
  //           //_matchEngine!.rewindMatch();
  //         }
  //       },
  //       child: Container(
  //         width: item_icons[index]['size'],
  //         height: item_icons[index]['size'],
  //         decoration: BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Colors.black12,
  //           // boxShadow: [
  //           //   BoxShadow(
  //           //     color: Colors.grey.withOpacity(0.3),
  //           //     spreadRadius: 5,
  //           //     blurRadius: 10,
  //           //   )
  //           // ]
  //         ),
      
  //         child: Center(
  //           child: SvgPicture.asset(
  //             item_icons[index]['icon'],
  //             width: item_icons[index]['icon_size'],
              
  //             ),
  //         ),
      
  //       ),
  //     );

  //   }),
  // ),
  //   ),

  // ),
          ],
        );


        }
        if(state.swipeStatus == SwipeStatus.completed){
          final now =DateTime.now();
          final remain  = now.difference(state.completedTime!);
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
                        //showPrefesSheet(context: context);
                      },
                      child: Icon(Icons.settings),
                    ),
                  )
                ],
              ),
            )
          );
        }
        
        else{
          return Center(child: Text('Get back after a while...'));
        }
      },
    );
  }
}