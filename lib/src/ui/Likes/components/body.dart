import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lomi/src/Blocs/AdBloc/ad_bloc.dart';
import 'package:lomi/src/Blocs/LikeBloc/like_bloc.dart';
import 'package:lomi/src/Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/likes_model.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Notification/notification_service.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';
import 'package:lomi/src/Data/Repository/SharedPrefes/sharedPrefes.dart';
import 'package:lomi/src/ui/Likes/components/like_card.dart';
import 'package:lomi/src/ui/itsAmatch/itsAmatch.dart';

import '../../../Blocs/MatchBloc/match_bloc.dart';
import '../../../Blocs/PaymentBloc/payment_bloc.dart';
import '../../Profile/profile.dart';
import '../../chat/chatscreen.dart';
import '../../payment/payment.dart';
import 'likes_image.dart';
import '../../payment/showPaymentDialog.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    //final inactiveMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isEmpty,).toList();
    //final activeMatches = UserMatch.matches.where((match) => match.userId == 1 && match.chat!.isNotEmpty,).toList();
    final RemoteConfigService remoteConfigService = RemoteConfigService();
    bool showAd = remoteConfigService.showAd();
    return SingleChildScrollView(
      controller: context.read<LikeBloc>().likeController,

      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return BlocBuilder<LikeBloc, LikeState>(
              builder: (context, state) {
                List<Like> likedMeUsers = [];
      
                
                if (state is LikeLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
      
                if (state is LikeLoaded) {
                  var subscribtion= SubscribtionStatus.notSubscribed;
                  if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedMonthly||context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedYearly || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribed6Months){
                    likedMeUsers = state.likedMeUsers;
                  }else
                  if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER ){
                    likedMeUsers = state.likedMeUsers;
                  }else if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed){
                    if(state.likedMeUsers.length >=2){
                      likedMeUsers = state.likedMeUsers.sublist(0,2);
                    }else{
                      likedMeUsers = state.likedMeUsers;
                      //.sublist(0,1);
                    }
                  }
                  return BlocListener<PaymentBloc, PaymentState>(
                    
                    listener: (context, state) {
                      // TODO: implement listener
                      subscribtion = state.subscribtionStatus;
                      
                    },
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Row(
                                children: [
      
                                  Text(
                                    "Likes",
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  SizedBox(width: 5,),
      
      
                                  SizedBox(
                                    child: FutureBuilder(
                                      future: context.read<DatabaseRepository>().getLikesCount(userId:context.read<AuthBloc>().state.user!.uid, gender: context.read<AuthBloc>().state.accountType!),
                                      builder: (context, AsyncSnapshot<int> snapshot){
                                        if(snapshot.hasError){
                                          return SizedBox();
                                        }
                                        if(snapshot.hasData){
                                          int? prevCount = SharedPrefes.getLikesCounts();
                                          if(prevCount!= null){
                                          if(snapshot.data!=null && (snapshot.data! > prevCount)){
                                            //NotificationService().showMessageReceivedNotifications(title: 'New Likes', body: 'you have new like', payload: 'likes', channelId: 'likes');
                                            SharedPrefes.setTempLikesCount(snapshot.data!);
                                            SharedPrefes.newLike.add('newLike');
                                            SharedPrefes.setLikesCount(snapshot.data!);
                                          }else{
                                            SharedPrefes.setTempLikesCount(-1);
      
                                          }
                                          }
                                          
                                          return Row(
                                            children: [
                                              Text(snapshot.data.toString()),
      
                                              // (snapshot.data!=null || snapshot.data! > prevCount) ?
                                              //   Container(
                                              //     height: 6,
                                              //     width: 6,
                                              //     decoration: BoxDecoration(
                                              //       shape:  BoxShape.circle,
                                              //       color: Colors.red,
                                                    
                                  
                                              //     ),
                                              //   )
                                              // :SizedBox()
                                            ],
                                          );
                                        }else{
                                          return SizedBox();
                                        }
                                      }),
                                  )
      
                               ],
                               )
                            ),
                            SizedBox(
                              height: 10,
                            ),
      
                            // SizedBox(
                            //   //height: 150,
                            //   child: ListView.builder(
                            //     shrinkWrap: true,
                            //     scrollDirection: Axis.vertical,
                            //     itemCount: inactiveMatches.length,
                            //     itemBuilder: (context, index){
                            //       return LikesImage(url: state.likedMeUsers[index].imageUrls[0], height: 120, width: 100,);
                            //     }
                            //     ),
                            // ),
      
                         
      
                            MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: GridView.builder(
                                  //controller: context.read<LikeBloc>().likeController,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.66,
                                          mainAxisSpacing: 8,
                                          crossAxisSpacing: 8),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.likedMeUsers.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          //context.read<AdBloc>().add(ShowInterstitialAd());
                                          //var subscribtion = context.read<PaymentBloc>().state.subscribtionStatus;
                                          if(!remoteConfigService.ETusersPay() && context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER){
                                            if(context.read<AdBloc>().state.isLoadedRewardedAd ==true || !showAd){
                                             showAd? context.read<AdBloc>().add(ShowRewardedAd(adType: AdType.rewardedOnline)):null;
                                             Navigator.push(context, MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          BlocProvider.value(value: context.read<ProfileBloc>(),
                                                              child: BlocProvider.value(value: context.read<LikeBloc>(),
                                                              child: BlocProvider.value(value:context.read<PaymentBloc>(),
                                                              child: BlocProvider.value(value:context.read<SharedpreferenceCubit>(),
                                                              child: BlocProvider.value(value:context.read<UserpreferenceBloc>(),
                                                              child: Profile(user: state.likedMeUsers[index].user,profileFrom: ProfileFrom.like, likedMeUser: state.likedMeUsers[index],ctrx: context, ))))))));
      
      
      
                                            }else{
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try again! ad loading...', style: TextStyle(fontSize: 11.sp, color: Colors.grey), ), backgroundColor: Colors.black38, ));
                                              context.read<AdBloc>().add(LoadRewardedAd());
                                            }
      
                                          }else
                                          if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedMonthly||context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedYearly || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribed6Months){
                                            Navigator.push(context, MaterialPageRoute(
                                                      builder: (ctx) =>
                                                          BlocProvider.value(value: context.read<ProfileBloc>(),
                                                              child: BlocProvider.value(value: context.read<LikeBloc>(),
                                                              child: BlocProvider.value(value:context.read<PaymentBloc>(),
                                                              child: BlocProvider.value(value:context.read<SharedpreferenceCubit>(),
                                                              child: BlocProvider.value(value:context.read<UserpreferenceBloc>(),
                                                              child: Profile(user: state.likedMeUsers[index].user,profileFrom: ProfileFrom.like, likedMeUser: state.likedMeUsers[index],ctrx: context, ))))))));
      
                                          }else{
                                            showPaymentDialog(context: context, paymentUi: PaymentUi.subscription);
                                           
                                          }
                                          
      
                                          
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: state.likedMeUsers[index].user)));
      
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment() ));
                                         },
                                     
                           
                                            child:  
                                                  LikeCard(
                                                      like: state.likedMeUsers[index],
                                                      showAd: showAd,
                                                      ));
      
                                        //LikesImage(url: state.likedMeUsers[index].user.imageUrls[0], height: 20,)
                                        
                                  }),
                            ),
      
                            // SizedBox(height: 25,),
                          ]),
                    ),
                  );
                } else {
                  return Text('something went wrong...');
                }
              },
            );
        },
      ),
    );
  }
}
