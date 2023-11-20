import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lomi/src/Blocs/AdBloc/ad_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';

import 'package:lomi/src/ui/home/components/userdrag.dart';
import 'package:lomi/src/ui/payment/showPaymentDialog.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Blocs/UserPreference/userpreference_bloc.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Models/likes_model.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../dataApi/icons.dart';
import 'swipecompleted.dart';

class SwipeCard extends StatelessWidget {
  const SwipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SwipeBloc, SwipeState>(
      listener: (context,state){
        if(state.swipeStatus == SwipeStatus.error){
          if(state.error == 'Exception: dailyMatch'){
            Future.delayed(const Duration(seconds: 3), (){
              context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something went wrong, come back tomorrow!')));

          }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.error??'something went wrong,')));
          }
        }
      },

      builder: (context, state) {
        if(state.swipeStatus == SwipeStatus.loading || state.swipeStatus == SwipeStatus.initial || state.swipeStatus == SwipeStatus.error){
        
          return const Center(child: CircularProgressIndicator(strokeWidth: 2,) );
          
        }
        if(state.swipeStatus == SwipeStatus.loaded){

         // NotificationService().showMessageReceivedNotifications(title: 'Match Loaded', body:'you have match for ${state.loadFor!.name}', payload: 'mnm');

          List<SwipeItem> _swipeItems = [];
          MatchEngine? _matchEngine;

          if(state.users.isEmpty ){
            //context.read<SwipeBloc>().add(SwipeEnded(completedTime: state.completedTime??DateTime.now()));
            Future.delayed(Duration(seconds: 2),(){

             context.read<SwipeBloc>().add(SwipeEnded(completedTime: state.completedTime??DateTime.now()));
             });
          }
          //state.users.forEach((user)
          for(var user in state.users)
           {
            _swipeItems.add(
              SwipeItem(
                content: user,
                likeAction: (){
                  //final user = (context.read<ProfileBloc>().state as ProfileLoaded).user;
                  context.read<SwipeBloc>().add(SwipeRightEvent(     
                    user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                    matchUser: user,
                    superLike: false
                    )
                  );
                },

                nopeAction: (){
                 context.read<SwipeBloc>().add(SwipeLeftEvent(
                    passedUser: user, 
                    user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                    ));
             
                },

                
                onSlideUpdate: (SlideRegion? region) async {
                  print("Region $region");
             },
                superlikeAction: (){
                    context.read<SwipeBloc>().add(SwipeRightEvent(     
                    user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                    matchUser: user,
                    superLike: true
                    )
                  );
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
                          if(state.loadFor == LoadFor.daily){
                            context.read<SwipeBloc>().add(SwipeEnded(completedTime: DateTime.now()));

                              Future.delayed(const Duration(seconds: 10), (){ 
                               context.read<SwipeBloc>().add(LoadUsers(userId: context.read<AuthBloc>().state.user!.uid , users: context.read<AuthBloc>().state.accountType! )); 

                               
                               });
                            NotificationService().scheduleNotifications(title: 'Daily Match', body: 'your time is up. your daily matches are ready to view', payload: 'daily matches');
   
                        }else{
                      
                          context.read<SwipeBloc>().add(SwipeEnded(completedTime: state.completedTime));
                          }
                        }, 
                        itemBuilder: (context, index){
                          print('>>>>.>>>>>>>>>>>>>>>>>>>${index}');
                          //return UserCard().userDrag(MediaQuery.of(context).size, _swipeItems[index].content, context);
                          return UserCard(user: state.users[index], matchEngine: _matchEngine,);
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
                      if(index == 1){
                       _matchEngine!.currentItem?.nope();
                     
                      }
                      if(index == 3){
                         _matchEngine!.currentItem?.like();
                      }
                      if(index == 2) _matchEngine!.currentItem?.superLike();
                      if(index == 0){
                        if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed){
                          if(context.read<AdBloc>().state.isLoadedRewardedAd){
                            context.read<AdBloc>().add(ShowRewardedAd(adType: AdType.rewardedRandom));
                            _matchEngine?.rewindMatch();
                          }
                        }else{
                        _matchEngine?.rewindMatch();
                        }
                        }
                      if(index == 4){ 
                        if(context.read<PaymentBloc>().state.subscribtionStatus != SubscribtionStatus.ET_USER ){
                          if(context.read<PaymentBloc>().state.boosts ==0){
                            showPaymentDialog(context: context, paymentUi: PaymentUi.boosts);
                          }else{
                            context.read<SwipeBloc>().add(BoostMe(user: (context.read<ProfileBloc>().state as ProfileLoaded).user, ));
                          }
                        }
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
 
          ],
        );


        }
        if(state.swipeStatus == SwipeStatus.completed){
          // final now =DateTime.now();
          // final remain  = now.difference(state.completedTime!);
          return SwipeCompletedWidget(state: state,);
        }
        // if(state.swipeStatus == SwipeStatus.error){
        //   //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('something went wrong come back later...')));
        //   return SwipeCompletedWidget(state: state);
        // }
        
        else{
          return Center(child: Text('Get back after a while...'));
        }
      },
    );
  }







}