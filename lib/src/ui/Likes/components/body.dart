import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lomi/src/Blocs/AdBloc/ad_bloc.dart';
import 'package:lomi/src/Blocs/LikeBloc/like_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/ui/Likes/components/like_card.dart';

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

    return SingleChildScrollView(
      child: BlocBuilder<LikeBloc, LikeState>(
        builder: (context, state) {
          if (state is LikeLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is LikeLoaded) {
            var subscribtion= SubscribtionStatus.notSubscribed;
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
                        child: Text(
                          "Likes",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
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
                                    if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER){
                                      if(context.read<AdBloc>().state.isLoadedRewardedAd ==true){
                                       context.read<AdBloc>().add(ShowRewardedAd(adType: AdType.rewardedOnline));
                                       Navigator.push(context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                    BlocProvider.value(value: context.read<ProfileBloc>(),
                                                        child: BlocProvider.value(value: context.read<LikeBloc>(),
                                                        child: Profile(user: state.likedMeUsers[index].user,profileFrom: ProfileFrom.like, likedMeUser: state.likedMeUsers[index],)))));



                                      }else{
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('check your internet connection or VPN and Try again! ad not loaded...', style: TextStyle(fontSize: 11.sp), ), backgroundColor: Colors.black12, ));
                                      }

                                    }else
                                    if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedMonthly||context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribedYearly || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.subscribed6Months){
                                      Navigator.push(context, MaterialPageRoute(
                                                builder: (ctx) =>
                                                    BlocProvider.value(value: context.read<ProfileBloc>(),
                                                        child: BlocProvider.value(value: context.read<LikeBloc>(),
                                                        child: BlocProvider.value(value:context.read<PaymentBloc>(),child: Profile(user: state.likedMeUsers[index].user,profileFrom: ProfileFrom.like, likedMeUser: state.likedMeUsers[index] ))))));

                                    }else{
                                      showPaymentDialog(context: context, paymentUi: PaymentUi.subscription);
                                    }
                                    

                                    
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: state.likedMeUsers[index].user)));

                                    //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment() ));
                                   },
                                  // child: BlocListener<AdBloc, AdState>(
                                  //     listenWhen: (previous, current) =>
                                  //         previous.isLoadedInterstitialAd ==
                                  //             true &&
                                  //         current.isLoadedInterstitialAd ==
                                  //             false,
                                  //     // => previous.reward == null && current.reward !=null,
                                  //     listener: (context, adState) {
                                  //       //if(adState.in != null){
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (ctx) =>
                                  //                   BlocProvider.value(
                                  //                       value: context.read<
                                  //                           ProfileBloc>(),
                                  //                       child: Profile(
                                  //                           user: state
                                  //                               .likedMeUsers[
                                  //                                   index]
                                  //                               .user))));

                                  //       //context.read<AdBloc>().add(ResetReward());

                                  //       // }
                                  //     },
                                      child: LikeCard(
                                          like: state.likedMeUsers[index]));

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
      ),
    );
  }
}
