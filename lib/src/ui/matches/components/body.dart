import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ChatBloc/chat_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/ui/Profile/profile.dart';

import '../../../Blocs/AdBloc/ad_bloc.dart';
import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../../Blocs/SharedPrefes/sharedpreference_cubit.dart';
import '../../../Data/Models/enums.dart';
import '../../chat/chatscreen.dart';
import '../../payment/showPaymentDialog.dart';
import 'chat_list.dart';
import 'matches_image_small.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    FocusNode focusNode = FocusNode();
   // final inactiveMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isEmpty,).toList();
   // final activeMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isNotEmpty,).toList();


    return BlocBuilder<MatchBloc, MatchState>(
      builder: (context, state) {
        if(state.matchStatus == MatchStatus.loading){
          return Center(child: CircularProgressIndicator(),); 
        }
        
        if(state.matchStatus == MatchStatus.loaded){
          //final inactiveMatches = state.matchedUsers.where((match) => !match.chatOpened).toList();
          //final activeMatches = state.matchedUsers.where((match) => match.chatOpened).toList(); 
          final inactiveMatches = state.matchedUsers;
          final activeMatches = state.activeMatches;


          return
         Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
             
              child: TextField(
                onChanged: (name){
                  context.read<MatchBloc>().add(SearchName(userId: context.read<AuthBloc>().state.user!.uid, gender: context.read<AuthBloc>().state.accountType!, name: name ));

                },
                decoration: InputDecoration(
                  hintText:focusNode.hasFocus?'Search Match': (context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed)? 'Search Match - Watch Ad First!':'Search Match',
                  contentPadding: EdgeInsets.zero,
                  icon: Icon(Icons.search,),
                  counterText: ''

                ),
                style: TextStyle(fontSize: 12),
                maxLines: 1,
                maxLength: 30,
                controller: controller,
                focusNode: focusNode,
                //autofocus: true,
                //readOnly: focusNode.hasFocus?false: true,
                //showCursor: true,
                
                
                onTapOutside: (event){
                  FocusManager.instance.primaryFocus!.unfocus();
                 // controller.clear();
                },
                onTap: (){
                  if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed ){
                 
                 if(focusNode.hasFocus){


                 }else{
                  //FocusManager.instance.primaryFocus!.unfocus();
                  if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                        context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedRandom));
                                        Future.delayed(const Duration(seconds: 4), (){
                                      
                                          FocusScope.of(context).requestFocus(focusNode);
                                                    
                                        });
                                        
                                                    
                      }else{
                        FocusManager.instance.primaryFocus!.unfocus();

                      }

                 }
                  }
                },
                
                
              ),

              ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20),
              child: Text(state.isUserSearching? 'Search Result': "New Matches", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            SizedBox(height: 10,),
            
    
            Padding(
              padding: const EdgeInsets.only(left:0.0),
              child: SizedBox(
                height: 150,
                child: (inactiveMatches.length !=0 || state.searchResult!.isNotEmpty )? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  controller: context.read<MatchBloc>().matchController,
                  itemCount: state.isUserSearching?state.searchResultFor==SearchResultFor.matched? state.searchResult?.length:1: inactiveMatches.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: (){
                       // Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(inactiveMatches[index])));

                          if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER){
                                    if(context.read<AdBloc>().state.isLoadedRewardedAd ==true){
                                     context.read<AdBloc>().add(ShowRewardedAd(adType: AdType.rewardedOnline));
                                     Navigator.push(context, MaterialPageRoute(
                                              builder: (ctx) =>
                                                  BlocProvider.value(value: context.read<ChatBloc>(),
                                                      child: BlocProvider.value(
                                                        value: context.read<MatchBloc>() ,
                                                        child: (state.isUserSearching && state.searchResultFor == SearchResultFor.findMe)?
                                                              BlocProvider.value(
                                                                value: context.read<ProfileBloc>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<SharedpreferenceCubit>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<UserpreferenceBloc>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<SwipeBloc>(),
                                                                  child: Profile(user: state.findMeResult![0], profileFrom: ProfileFrom.search))))):
                                                              ChatScreen(state.isUserSearching?state.searchResult![index]: inactiveMatches[index]) 
                                                                                          ))));



                                    }else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('check your internet connection or VPN and Try again! ad not loaded...')));
                                    }

                                  }else
                                  if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedMonthly||context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedYearly || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribed6Months){
                                    Navigator.push(context, MaterialPageRoute(
                                              builder: (ctx) =>
                                                  BlocProvider.value(value: context.read<ChatBloc>(),
                                                      child: BlocProvider.value(
                                                        value: context.read<MatchBloc>() ,
                                                        child:
                                                              (state.isUserSearching && state.searchResultFor == SearchResultFor.findMe)?
                                                              BlocProvider.value(
                                                                value: context.read<ProfileBloc>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<SharedpreferenceCubit>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<UserpreferenceBloc>(),
                                                                child: BlocProvider.value(
                                                                value: context.read<SwipeBloc>(),
                                                                child: Profile(user: state.findMeResult![0], profileFrom: ProfileFrom.search))))):
                                                              ChatScreen(state.isUserSearching?state.searchResult![index]: inactiveMatches[index]) 
                                                                                          ))));

                                  }else{
                                    showPaymentDialog(context: context, paymentUi: PaymentUi.subscription);
                                  }

                                  controller.clear();
                                  context.read<MatchBloc>().add(SearchName(userId: context.read<AuthBloc>().state.user!.uid, gender: context.read<AuthBloc>().state.accountType!, name: '' ));
                        },
                      child:state.isUserSearching? state.searchResultFor == SearchResultFor.matched? MatchesImage(match: state.searchResult![index],height: 120, width: 100, ): state.findMeResult!.isNotEmpty? MatchesImage(url: state.findMeResult?[0].imageUrls[0]): SizedBox()
                      :MatchesImage(match: inactiveMatches[index], height: 120, width: 100,));
                  }
                  ):
                  Padding(
                    padding: const EdgeInsets.only(left:20.0),
                    child: Container(
                                    height: 150,
                                    width: 120,
                                    decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.teal: Colors.green),
                    borderRadius: BorderRadius.circular(20)
                                    ),
                                    child: Center(child: Text('New matches\nwill appear\n here',textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10,fontWeight: FontWeight.w300),)),
                    ),
                  ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top:8.0, left: 28),
            //   child: Text("Likes", style: Theme.of(context).textTheme.bodyLarge,),
            // ),
            
            SizedBox(height: 25,),
    
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Messages", style: Theme.of(context).textTheme.bodyLarge,),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: activeMatches.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed){
                        
                      showPaymentDialog(context: context, paymentUi: PaymentUi.subscription);
                    }else{
                      
                      context.read<ChatBloc>().add(LoadChats(userId: context.read<AuthBloc>().state.user!.uid, users: context.read<AuthBloc>().state.accountType! , matchedUserId: activeMatches[index].userId));
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(activeMatches[index]) ));
            
                      Navigator.push(context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                    BlocProvider.value(value: context.read<ChatBloc>(),
                                                        child: ChatScreen(activeMatches[index]) )));
                    }
                    },
                    child: ChatList(match: activeMatches[index])
                    
                    
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 10.0),
                    //   child: Row(
                    //     mainAxisSize: MainAxisSize.min,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       MatchesImage(url: activeMatches[index].imageUrls[0],
                    //        height: 60,width: 60,shape: BoxShape.circle,),
                    //        Padding(
                    //          padding: const EdgeInsets.all(8.0),
                    //          child: Column(
                              
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //            children: [
                    //             SizedBox(height: 5,),
                    //              Text(activeMatches[index].name,
                    //                   style: Theme.of(context).textTheme.bodyLarge,
                                 
                    //              ),
                    //             const SizedBox(height: 5,),
            
                                
                                  //width: double.infinity,
                            //  StreamBuilder(
                            //         stream: DatabaseRepository().getLastMessage(activeMatches[index].userId, activeMatches[index].userId),
                            //         //context.read()<DatabaseRepository>().getLastMessage,
                            //         builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                            //           return 
                            //           Row(
                            //             //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //             //mainAxisSize: MainAxisSize.max,
                            //             children: [
                            //               // Container(
                            //               //   width: MediaQuery.of(context).size.width * 0.4,
                            //               //   child: Text(
                            //               //     snapshot.data.isNotEmpty? snapshot.data?[0].message ?? '', 
                            //               //     overflow: TextOverflow.ellipsis, 
                            //               //     softWrap: true, 
                            //               //    // maxLines: 1,
                            //               //     ),
                            //               // ),
                            //               SizedBox(width: MediaQuery.of(context).size.width * 0.06,),
                            //               Text('${snapshot.data?[0].timestamp.hour}:${snapshot.data?[0].timestamp.minute} PM')
                            //             ],
                            //           );
                                      
                            //         }
                            //       ),
                              
                                               
                                //   Text(
                                //     'Hello from the other side',
            
                                //    // activeMatches[index].chat,
                                //     //activeMatches[index].chat![0].messages[0].message,
                                //       style: Theme.of(context).textTheme.bodySmall,
                                 
                                //  ),
                                //  const SizedBox(height: 5,),
                                //  Text(
                                //   activeMatches[index].chat,
                                //   //activeMatches[index].chat![0].messages[0].timeString,
                                //       style: Theme.of(context).textTheme.bodySmall,
                                 
                              //     )
                              //  ],
                          //    );
                          //  ),
                          //  Spacer(),
            
                          //  Padding(
                          //    padding: const EdgeInsets.only(top: 15.0),
                          //    child: Text('7:03 PM',
                          //    style: Theme.of(context).textTheme.bodySmall,
                          //    ),
                          //  )
                    //     ],
                    //   ),
                    // ),
                  );
                }),
            )
    
    
          ]),
        );

        }else{
          return Text('something went wrong...');
        }
      },
    );
    
  }
}