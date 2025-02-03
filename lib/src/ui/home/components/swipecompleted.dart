import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/ui/payment/showPaymentDialog.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../Blocs/AdBloc/ad_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Repository/Remote/remote_config.dart';
import '../../UserProfile/userprofile.dart';

class SwipeCompletedWidget extends StatelessWidget {
  const SwipeCompletedWidget({super.key, required this.state});

  final SwipeState state;

  @override
  Widget build(BuildContext context) {
    final now =DateTime.now();
    Duration remain;
    if(state.completedTime == null){
      remain = const Duration(hours: 24);
    }else
    if(state.loadFor == LoadFor.daily){
      remain = const Duration(hours: 24);
      
    }else{
      var diff = now.difference(state.completedTime!);
      remain = Duration(seconds: 86400 - diff.inSeconds, );

    }
    var isDark = Theme.of(context).brightness == ThemeMode.dark;

    final RemoteConfigService remoteConfigService = RemoteConfigService();
    bool showAd = remoteConfigService.showAd();
    
    // var remain2  =state.completedTime ==null? Duration(seconds: 60) : Duration(seconds: 60 - now.difference(state.completedTime!).inSeconds);
    // if(state.completedTime != null){
    //   var isLong =now.difference(state.completedTime!).inSeconds;
    //   if(now.difference(state.completedTime!).inSeconds <3) remain = const Duration(seconds: 60);
    // }
    

    return  SizedBox(
      child: BlocBuilder<AdBloc,AdState>(
        builder: (context, state) {
          
          if(state.totalAdWatchedReOn ==10){
        // Future.delayed(const Duration(hours: 1), (){
        //   context.read<AdBloc>().add(ResetTotalReON());

        // });
        context.read<AdBloc>().add(TimeOutAd(completedTimeAd: DateTime.now()));

      }
      
      if(state.totalAdWatchedReOn == 100 && state.completedTimeAd != null && DateTime.now().difference(state.completedTimeAd!).inMinutes > 60){
        context.read<AdBloc>().add(ResetTotalReON());

      }
      // if(state.totalAdWatchedReOn >10){
      //   if(state.completedTimeAd == null){
      //     context.read<AdBloc>().add(TimeOutAd(completedTimeAd: DateTime.now()));

      //   }
      //}
          return Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                
                          children: [
                            // Text('Thats it for today \ncome back Tomorrow!'),
                            // Text(
                            //   '${remain.inHours}:${remain.inMinutes}:${remain.inSeconds} remains',
                            //   style: Theme.of(context).textTheme.bodyLarge,
    
                            // ),
                            SizedBox(height:45.h),
                           //  Spacer(),
    
                             BlocBuilder<ThemeCubit,ThemeMode>(
                               builder: (context,state) {
                                isDark = state == ThemeMode.dark;
                                 return SlideCountdownSeparated(
                                  duration: remain,
                                  height: 60.h,
                                  width: 60.w,
                                  decoration: BoxDecoration(
                                    color: isDark? Colors.grey[800]: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  textStyle: TextStyle(fontSize: 25.sp, color: Colors.white),
                                  padding: EdgeInsets.all(10),
                                  onDone: () {
                                    context.read<SwipeBloc>().add(CheckLastTime());
                                  },
                                 
                            );
                               }
                             ),
                            SizedBox(height: 15.h,),
                            Text('That\'s it for today \ncome back Tomorrow!',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                                textAlign: TextAlign.center,
                            ),
    
                             SizedBox(height: 25.h,),
                            const Padding(
                              padding: const EdgeInsets.symmetric(horizontal:15.0),
                              child: const Divider(),
                            ),
                             SizedBox(height: 25.h,),

                            //Spacer(),
                            Text('Till then...', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp),),
                             SizedBox(height: 25.h,),

                            BlocListener<AdBloc, AdState>(
                              listener: (context, state) {
                                // if(state.rewardedAdType == AdType.rewardedNearby){
                                //   context.read<SwipeBloc>().add(LoadUserAd(
                                //       userId: context.read<AuthBloc>().state.user!.uid, 
                                //       users: context.read<AuthBloc>().state.accountType!,
                                //       discoverBy: DiscoverBy.nearby,
                                //       limit: 30
                                //       ));
                                  
                                //   context.read<AdBloc>().add(ResetReward());

                                // }
                              },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                  
                                  child: InkWell(
                                    onTap: (){
                                      if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed){
                                        if(remoteConfigService.showAdREORN()){
                                        
                                        if(!context.read<AdBloc>().state.isLoadedRewardedAd){
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('check your internet connection or VPN and Try again! ad not loaded...', style: TextStyle(fontSize: 11.sp, color: Colors.grey),), backgroundColor: Colors.black38,));
                                          context.read<AdBloc>().add(LoadRewardedAd());
                                        }else{
                                        
                                        context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedNearby));

                                      context.read<SwipeBloc>().add(LoadUserAd(
                                      userId: context.read<AuthBloc>().state.user!.uid, 
                                      users: context.read<AuthBloc>().state.accountType!,
                                      loadFor: LoadFor.adNearby,
                                      limit: 30
                                      ));
                                        }

                                      }else{

                                        context.read<SwipeBloc>().add(LoadUserAd(
                                            userId: context.read<AuthBloc>().state.user!.uid, 
                                            users: context.read<AuthBloc>().state.accountType!,
                                            loadFor: LoadFor.adNearby,
                                            limit: 30
                                            ));

                                      }
                                      }else{
                                        context.read<SwipeBloc>().add(LoadUserAd(
                                          userId: context.read<AuthBloc>().state.user!.uid, 
                                          users: context.read<AuthBloc>().state.accountType!,
                                          loadFor: LoadFor.adNearby,
                                          limit: 30
                                          ));

                                      }
                                    },
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                                      child: Column(
                                    
                                        children: [
                                          Icon(Icons.location_on_outlined,color: Colors.grey,size: 35.sp, ),
                                          SizedBox(height: 10.h,),
                                          Text('Find Matches around you\n (within ${remoteConfigService.getNumbers()['maxKmNearBy']}km)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey), ),
                                          SizedBox(height: 10.h,),
                                          BlocBuilder<PaymentBloc,PaymentState>(
                                            builder: (context,state) {
                                              return Text( (state.subscribtionStatus == SubscribtionStatus.ET_USER || state.subscribtionStatus == SubscribtionStatus.notSubscribed) && remoteConfigService.showAdREORN()?
                                               'Watch Ad' : ''
                                               , style: TextStyle(fontSize: 11.sp,color: Colors.grey),);
                                            }
                                          ),
                                         
                                        BlocBuilder<SwipeBloc,SwipeState>(
                                          builder: (context,state){
                                            if(state.loadFor == LoadFor.adNearby){
                                              return SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 2,));
                                            }else{
                                              return const SizedBox(height:10);
                                            }

                                          })
                                        ],
                                      ),
                                    ),
                                  )
  
                                )
                            ),
  

                              
                            
                            

                            SizedBox(height: 25.h,),
                            const Spacer(),
                            AbsorbPointer(
                              absorbing: state.totalAdWatchedReOn >=10,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                      
                                      child: InkWell(
                                        splashColor: state.totalAdWatchedReOn>=10?Colors.white:null,
                                        highlightColor: state.totalAdWatchedReOn>=10?Colors.white:null,
                                        onTap: (){
                                          if((context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER  || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed) && remoteConfigService.showAdREORN() ){
                                          if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                            context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedOnline));
                                          if(context.read<AdBloc>().state.adWatchedOnline! >=1 ){
                            
                                          context.read<SwipeBloc>().add(LoadUserAd(
                                            userId: context.read<AuthBloc>().state.user!.uid, 
                                            users: context.read<AuthBloc>().state.accountType!,
                                            loadFor: LoadFor.adOnline,
                                            limit: 1
                                            )
                                            );
                            
                                          }

                                          }
                                          else{
                                                
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try again! ad loading...', style: TextStyle(fontSize: 11.sp, color: Colors.grey),), backgroundColor: Colors.black38,));
                                                    context.read<AdBloc>().add(LoadRewardedAd());
                                     
                                        }
                                          }else{
                                            context.read<SwipeBloc>().add(LoadUserAd(
                                            userId: context.read<AuthBloc>().state.user!.uid, 
                                            users: context.read<AuthBloc>().state.accountType!,
                                            loadFor: LoadFor.adOnline,
                                            limit: 1
                                            )
                                            );

                                            context.read<AdBloc>().add(IncreaseReOn());

                                          }
                              
                                          
                                        },
                                        child: Padding(
                                          padding:  EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                                          child: Column(
                                        
                                            children: [
                                              Row(children: [
                                                Icon(Icons.motion_photos_on_outlined,color: Colors.green,size: 25.sp, ),
                                              SizedBox(width: 10.h,),
                                              BlocBuilder
                                              <PaymentBloc,PaymentState>(
                                                builder: (context,statePayment) {
                                                  var txt = state.totalAdWatchedReOn <10? ' - (${context.read<AdBloc>().state.adWatchedOnline}/2)':'';
                                                  return Text(
                                                    (context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER  || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed)&&remoteConfigService.showAdREORN()?
                                                    'Watch 2 Ads - Get 1 Recently Active Match$txt'
                                                    :'Get 1 Recently Active Match', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey), );
                                                }
                                              ),
                                              state.totalAdWatchedReOn >=10&&state.completedTimeAd!=null ?  Padding(
                                                        padding:  EdgeInsets.only(left:20.0.w),
                                                        child:  SlideCountdown(
                                                          duration: Duration(seconds: 3600 - DateTime.now().difference(state.completedTimeAd??DateTime.now()).inSeconds),
                                                        
                                                        textStyle: TextStyle(fontSize: 9, color: Colors.white),
                                                        padding: EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                                      
                                                        ),
                                                      )
                                                : const SizedBox(),

                                                Spacer(),
                                        BlocBuilder<SwipeBloc,SwipeState>(
                                          builder: (context,state){
                                            if(state.loadFor == LoadFor.adOnline){
                                              return SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 2,));
                                            }else{
                                              return SizedBox();
                                            }

                                          })
                              
                                              ],
                                              )
                                             
                                            ],
                                          ),
                                        ),
                                      )
                                
                                    ),
                              ),
                            ),
                            
                            SizedBox(height: 20.h,),

                            AbsorbPointer(
                              absorbing: state.totalAdWatchedReOn >=10,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                      //color: state.totalAdWatchedReOn<=10? Colors.grey.withOpacity(0.8):null,
                                      
                                      child: InkWell(
                                        splashColor: state.totalAdWatchedReOn>=10?Colors.white:null,
                                        highlightColor: state.totalAdWatchedReOn>=10?Colors.white:null,
                                        onTap: (){
                                          if((context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER  || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed) && remoteConfigService.showAdREORN() ){
                                          if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                            showAd?context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedRandom)):null;
                              
                                          context.read<SwipeBloc>().add(LoadUserAd(
                                          userId: context.read<AuthBloc>().state.user!.uid, 
                                          users: context.read<AuthBloc>().state.accountType!,
                                          loadFor: LoadFor.adRandom,
                                          limit: 1
                                          ));
                              
                                          }else{
                                                
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try again! ad not loaded...', style: TextStyle(fontSize: 11.sp, color: Colors.grey),), backgroundColor: Colors.black38,));
                                                    context.read<AdBloc>().add(LoadRewardedAd());
                                     
                                        }


                                          }else{
                                            
                                            context.read<SwipeBloc>().add(LoadUserAd(
                                              userId: context.read<AuthBloc>().state.user!.uid, 
                                              users: context.read<AuthBloc>().state.accountType!,
                                              loadFor: LoadFor.adRandom,
                                              limit: 1
                                              )
                                            );

                                            context.read<AdBloc>().add(IncreaseReOn());
                            
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                                          child: Column(
                                        
                                            children: [
                                              Row(
                                                children: [
                                                Icon(Icons.verified,color: Colors.grey,size: 25.sp, ),
                                                SizedBox(width: 10.h,),
                                                BlocBuilder<PaymentBloc,PaymentState>(
                                                  builder: (context,state) {
                                                    return Text((context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER || context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.notSubscribed)&&remoteConfigService.showAdREORN()?
                            
                                                    'Watch Ad - Get 1 random Match' : 'Get 1 random Match'
                                                    ,textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey), );
                                                  }
                                                ),
                            
                                                state.totalAdWatchedReOn >=10 && state.completedTimeAd !=null? Padding(
                                                  padding:  EdgeInsets.only(left:20.0.w),
                                                  child: SlideCountdown(
                                                    duration: Duration(seconds: 3600 - DateTime.now().difference(state.completedTimeAd??DateTime.now()).inSeconds),
                                                  
                                                  textStyle: TextStyle(fontSize: 9.sp, color: Colors.white),
                                                  padding: EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                                
                                                  ),
                                                ):SizedBox(),
                                                Spacer(),
                                        BlocBuilder<SwipeBloc,SwipeState>(
                                          builder: (context,state){
                                            if(state.loadFor == LoadFor.adRandom){
                                              return SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 2,));
                                            }else{
                                              return SizedBox();
                                            }

                                          })
                              
                                              ],
                                              )
                                             
                                            ],
                                          ),
                                        ),
                                      )
                                
                                    ),
                              ),
                            ),
                            

                             SizedBox(height: 15.h,),


                            // ElevatedButton(
                            //   onPressed: (){
                            //     context.read<SwipeBloc>().add(LoadUsers(
                            //       userId: context.read<AuthBloc>().state.user!.uid, 
                            //       users: context.read<AuthBloc>().state.accountType!,
                            //       user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                            //       prefes: (context.read<UserpreferenceBloc>().state as UserPreferenceLoaded).userPreference
                            //       ));
                            //   }, 
                            //   child: Text('get Matches')
                              
                            //   ),

                           // SizedBox(height: 55,),

                           SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                    
                                    child: InkWell(
                                      onTap: (){
                                        if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER && !remoteConfigService.ETbuyQP()){
                                        if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                          context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedPrincess));
                                          if(context.read<AdBloc>().state.adWatchedPrincess!>= remoteConfigService.getNumbers()['adsForPrincess'] ){

                                              context.read<SwipeBloc>().add(LoadUserAd(
                                              userId: context.read<AuthBloc>().state.user!.uid, 
                                              users: context.read<AuthBloc>().state.accountType!,
                                              loadFor: LoadFor.adPrincess,
                                              limit: 1
                                              ));
                                          }
                            
                                        }else{
                                                
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try again! ad loading...', style: TextStyle(fontSize: 11.sp, color: Colors.grey),), backgroundColor: Colors.black38,));
                                                    context.read<AdBloc>().add(LoadRewardedAd());
                                     
                                        }

                                        }else{

                                          if(context.read<PaymentBloc>().state.superLikes >0 ){
                                           // context.read<PaymentBloc>().add(ConsumeSuperLike());

                                            context.read<SwipeBloc>().add(LoadUserAd(
                                              userId: context.read<AuthBloc>().state.user!.uid, 
                                              users: context.read<AuthBloc>().state.accountType!,
                                              loadFor: LoadFor.adPrincess,
                                              limit: 1
                                              ));

                                          }else{
                                            showPaymentDialog(context:context, paymentUi: PaymentUi.superlikes);
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(vertical: 14.h, horizontal: 25.w),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            context.read<AuthBloc>().state.accountType ==Gender.men? Icon(LineIcons.crown, color: Colors.pink[300], size: 25.sp, ):Icon(FontAwesomeIcons.userTie, color: Colors.black, size: 20.sp, ),
                                        SizedBox(width: 10,),
                                        Text(
                                          (context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER && !remoteConfigService.ETbuyQP()) ?
                                              'Watch ${remoteConfigService.getNumbers()['adsForPrincess']} Ads - Get 1 ${context.read<AuthBloc>().state.accountType == Gender.women?'Gentle Man':'Princess'} - (${context.read<AdBloc>().state.adWatchedPrincess}/${remoteConfigService.getNumbers()['adsForPrincess']}) watched!'
                                              :context.read<AuthBloc>().state.accountType ==Gender.men?'1 Super Like - Get 1 Princess':'1 Super Like - Get 1 Gentle Men' , 

                                           
                                        textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey), 
                                        ),
                                        Spacer(),
                                        BlocBuilder<SwipeBloc,SwipeState>(
                                          builder: (context,state){
                                            if(state.loadFor == LoadFor.adPrincess){
                                              return SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 2,));
                                            }else{
                                              return SizedBox();
                                            }

                                          })
                            
                                        ],),
                                      ),
                                    )
                              
                                  ),
                            ),

                            SizedBox(height: 15.h,),

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                    
                                    child: InkWell(
                                      onTap: (){
                                        if(context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER && !remoteConfigService.ETbuyQP()){
                                        if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                          context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedQueen));
                                        if(context.read<AdBloc>().state.adWatchedQueen! >= remoteConfigService.getNumbers()['adsForQueen'] ){
                                        context.read<SwipeBloc>().add(LoadUserAd(
                                        userId: context.read<AuthBloc>().state.user!.uid, 
                                        users: context.read<AuthBloc>().state.accountType!,
                                        loadFor: LoadFor.adQueen,
                                        limit: 1
                                        ));
                                        }
                            
                                        }else{
                                                
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Try again! ad not loaded...', style: TextStyle(fontSize: 11.sp, color: Colors.grey),), backgroundColor: Colors.black38,));
                                                    context.read<AdBloc>().add(LoadRewardedAd());
                                     
                                        }
                                        }else{
                                          if(context.read<PaymentBloc>().state.boosts >0){
                                            
                                            context.read<SwipeBloc>().add(LoadUserAd(
                                            userId: context.read<AuthBloc>().state.user!.uid, 
                                            users: context.read<AuthBloc>().state.accountType!,
                                            loadFor: LoadFor.adQueen,
                                            limit: 1
                                            ));

                                          }else{
                                            showPaymentDialog(context: context, paymentUi: PaymentUi.boosts);
                                            
                                          }
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            context.read<AuthBloc>().state.accountType == Gender.men? Icon(LineIcons.crown,color: Colors.amber,size: 25.sp, ):Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                                              child: Icon(FontAwesomeIcons.crown, color: Colors.amber, size: 22.sp, ),
                                            ),
                                            SizedBox(width: 10.h,),
                                            Text(
                                              (context.read<PaymentBloc>().state.subscribtionStatus == SubscribtionStatus.ET_USER && !remoteConfigService.ETbuyQP()) ?
                                              'Watch ${remoteConfigService.getNumbers()['adsForQueen']} Ads - Get 1 ${context.read<AuthBloc>().state.accountType == Gender.women?'King':'Queen'} - (${context.read<AdBloc>().state.adWatchedQueen }/${remoteConfigService.getNumbers()['adsForQueen']}) watched!'
                                              :context.read<AuthBloc>().state.accountType == Gender.women?'1 Boost - Get 1 King': '1 Boost - Get 1 Queen' , 
                                              textAlign: TextAlign.center, style: TextStyle(fontSize: 11.sp, color: Colors.grey), ),

                                            Spacer(),
                                        BlocBuilder<SwipeBloc,SwipeState>(
                                          builder: (context,state){
                                            if(state.loadFor == LoadFor.adQueen){
                                              return SizedBox(
                                                height: 10,
                                                width: 10,
                                                child: CircularProgressIndicator(strokeWidth: 2,));
                                            }else{
                                              return SizedBox();
                                            }

                                          })
                                        ],),
                                      ),
                                    )
                              
                                  ),
                            ),
    
                            //   ElevatedButton(
                            //     onPressed: (){
                            //       if(context.read<AdBloc>().state.isLoadedRewardedAd){
                            //         context.read<AdBloc>().add(ShowRewardedAd());
                                  
                            //         context.read<SwipeBloc>().add(LoadUserAd(
                            //         userId: context.read<AuthBloc>().state.user!.uid, 
                            //         users: context.read<AuthBloc>().state.accountType!,
                            //         discoverBy: DiscoverBy.online,
                            //         limit: 1
                            //         ));
    
                            //       }
    
                            //     }, 
    
    
    
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //         Icon(Icons.video_collection),
                            //         Text('Watch Ad to get Random Match (${context.read<AdBloc>().state.adWatchedQueen }-watched)')
                            //       ],),
                            //     ),

                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.grey[400],
                            //       foregroundColor: Colors.black

                            //     ) ,
                            //     ),
    
                            
                            // ElevatedButton(
                            //     onPressed: (){
                            //       if(context.read<AdBloc>().state.isLoadedRewardedAd){
                            //         context.read<AdBloc>().add(ShowRewardedAd());
                                  
                            //         context.read<SwipeBloc>().add(LoadUserAd(
                            //         userId: context.read<AuthBloc>().state.user!.uid, 
                            //         users: context.read<AuthBloc>().state.accountType!,
                            //         discoverBy: DiscoverBy.online,
                            //         limit: 1
                            //         ));
    
                            //       }
    
                            //       if(context.read<AdBloc>().state.reward!.amount >= 50){
    
                            //         context.read<SwipeBloc>().add(LoadUserAd(
                            //         userId: context.read<AuthBloc>().state.user!.uid, 
                            //         users: context.read<AuthBloc>().state.accountType!,
                            //         discoverBy: DiscoverBy.online,
                            //         limit: 1
                            //         ));
    
    
                            //       }
    
                            //     }, 
                            //     child: Padding(
                            //       padding: const EdgeInsets.all(8.0),
                            //       child: Row(
                            //         //mainAxisSize: MainAxisSize.min,
                            //         children: [
                            //         Icon(Icons.video_collection),
                            //         Text('Watch an Ad get 1 online user')
                            //       ],),
                            //     ),

                            //     style: ElevatedButton.styleFrom(
                            //       backgroundColor: Colors.grey[400],
                            //       foregroundColor: Colors.black

                            //     ) ,
                            //     ),

                                Spacer(),
    
    
                            
                            
                            
                          ],
                        
                      ),

                      BlocBuilder<ThemeCubit,ThemeMode>(
                       
                        builder: (context,state) {
                           isDark = state==ThemeMode.dark;
                          return Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FloatingActionButton(
                                      onPressed: (){
                                        showPrefesSheet(context: context);
                                      },
                                      backgroundColor:isDark?Colors.grey[900]: Colors.white,
                                      foregroundColor:isDark?Colors.grey[400]: Colors.grey[900],
                                      child: Icon(Icons.settings),
                                    ),
                                  ),
                                );
                        }
                      )
            ],
          );
        }
      ),
    );
  }





  void showPrefesSheet({required BuildContext context}) {
    var state = context.read<UserpreferenceBloc>().state;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return SizedBox(
          height: MediaQuery.of(context).size.height*0.43,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(height: 35,),
                  
                Card(
                        elevation: 2,
                        color: 
                        isDark ? state.userPreference!.discoverBy ==DiscoverBy.habeshawelogic.index?  Colors.grey[800] :Colors.grey[900] : state.userPreference!.discoverBy ==DiscoverBy.habeshawelogic.index? Colors.grey[400]: Colors.white,
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
                                  state.userPreference!.discoverBy! == DiscoverBy.habeshawelogic.index, 
                                  onChanged: (value){
                                    
                                    context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.habeshawelogic.index), users: context.read<AuthBloc>().state.accountType!, ));
                                    print(DiscoverBy.habeshawelogic.index);
                                   // isThereChange = true;
                                   Navigator.pop(context);
                                  }),
                                ],
                              ),
                              Text('HabeshaWe algorithm gives you the best profiles who is rated beautiful Habesha matches around the world.',
                               style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600], fontSize: 11.sp),
                             ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 5,),
                  
                  
              Card(
                        elevation: 2,
                        color: isDark ? state.userPreference!.discoverBy == DiscoverBy.preference.index?  Colors.grey[800] :Colors.grey[900]  : state.userPreference!.discoverBy == DiscoverBy.preference.index? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                        
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Preference'),
                                    Switch(value: state.userPreference!.discoverBy! == DiscoverBy.preference.index, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.preference.index), users: context.read<AuthBloc>().state.accountType!,  ));
                                     // isThereChange = true;
                                     Navigator.pop(context);
                                    }),
                                  ],
                                ),
                            //     Text('You will get matches based on your preferences once in a day. your preference include all your profile information including age range that will probably will match with your choice and profile information.',
                            // style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                            //                 ),
                  
                          
                
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 5,),
                  
                      Card(
                        elevation: 2,
                        color: isDark ? state.userPreference!.discoverBy ==DiscoverBy.nearby.index?  Colors.grey[800] :Colors.grey[900] : state.userPreference!.discoverBy ==DiscoverBy.nearby.index? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Nearby Matches'),
                                    Switch(value: state.userPreference!.discoverBy! == DiscoverBy.nearby.index, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.nearby.index), users: context.read<AuthBloc>().state.accountType!,));
                                     // isThereChange = true;
                                     Navigator.pop(context);
                                    }),
                                  ],
                                ),
                            //     Text('find peoples nearby within 2km away from you. this method is free you can use it anytime of the day with out time limit if there are peoples near you they will appear.',
                            // style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                            //                 ),
                             
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
