import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../../Blocs/AdBloc/ad_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/enums.dart';
import '../../UserProfile/userprofile.dart';

class SwipeCompletedWidget extends StatelessWidget {
  const SwipeCompletedWidget({super.key, required this.state});

  final SwipeState state;

  @override
  Widget build(BuildContext context) {
    final now =DateTime.now();
    Duration remain;
    if(state.completedTime == null){
      remain = Duration();
    }else
    if(state.loadFor == LoadFor.daily){
      remain = const Duration(hours: 24);
      
    }else{
      var diff = now.difference(state.completedTime!);
      remain = Duration(seconds: 86400 - diff.inSeconds, );

    }
    
    // var remain2  =state.completedTime ==null? Duration(seconds: 60) : Duration(seconds: 60 - now.difference(state.completedTime!).inSeconds);
    // if(state.completedTime != null){
    //   var isLong =now.difference(state.completedTime!).inSeconds;
    //   if(now.difference(state.completedTime!).inSeconds <3) remain = const Duration(seconds: 60);
    // }
    

    return  SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        
                  children: [
                    // Text('Thats it for today \ncome back Tomorrow!'),
                    // Text(
                    //   '${remain.inHours}:${remain.inMinutes}:${remain.inSeconds} remains',
                    //   style: Theme.of(context).textTheme.bodyLarge,
    
                    // ),
                    SizedBox(height:45),
                    Spacer(),
    
                     SlideCountdownSeparated(
                      duration: remain,
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      textStyle: TextStyle(fontSize: 25, color: Colors.white),
                      padding: EdgeInsets.all(10),
                     
                    ),
                    SizedBox(height: 15,),
                    Text('Thats it for today \ncome back Tomorrow!',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                    ),
    
                    const SizedBox(height: 25,),
                    const Divider(),
                    const SizedBox(height: 25,),

                    Spacer(),
                    Text('Till then...', style: Theme.of(context).textTheme.bodySmall,),

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
                              if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedNearby));

                              context.read<SwipeBloc>().add(LoadUserAd(
                              userId: context.read<AuthBloc>().state.user!.uid, 
                              users: context.read<AuthBloc>().state.accountType!,
                              loadFor: LoadFor.adNearby,
                              limit: 30
                              ));

                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                              child: Column(
                            
                                children: [
                                  Icon(Icons.location_on_outlined,color: Colors.grey,size: 35, ),
                                  SizedBox(height: 10,),
                                  Text('Find Matches around you\n (within 2km)', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey), ),
                                  SizedBox(height: 10,),
                                  Text('Watch Ad', style: TextStyle(),)
                                ],
                              ),
                            ),
                          )
  
                        )
                    ),
  

                      
                    
                    

                    SizedBox(height: 25,),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                            
                            child: InkWell(
                              onTap: (){
                                if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                  context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedRandom));
                    
                                context.read<SwipeBloc>().add(LoadUserAd(
                                userId: context.read<AuthBloc>().state.user!.uid, 
                                users: context.read<AuthBloc>().state.accountType!,
                                loadFor: LoadFor.adRandom,
                                limit: 1
                                ));
                    
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: Column(
                              
                                  children: [
                                    Row(children: [
                                      Icon(Icons.verified,color: Colors.grey,size: 25, ),
                                    SizedBox(width: 10,),
                                    Text('Watch Ad - Get 1 random Match', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey), ),
                    
                                    ],)
                                   
                                  ],
                                ),
                              ),
                            )
                      
                          ),
                    ),

                    SizedBox(height: 20,),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                            
                            child: InkWell(
                              onTap: (){
                                if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                  context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedOnline));
                    
                                context.read<SwipeBloc>().add(LoadUserAd(
                                userId: context.read<AuthBloc>().state.user!.uid, 
                                users: context.read<AuthBloc>().state.accountType!,
                                loadFor: LoadFor.adOnline,
                                limit: 1
                                ));
                    
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: Column(
                              
                                  children: [
                                    Row(children: [
                                      Icon(Icons.motion_photos_on_outlined,color: Colors.green,size: 25, ),
                                    SizedBox(width: 10,),
                                    Text('Watch 2 Ads - Get 1 Online Match', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey), ),
                    
                                    ],)
                                   
                                  ],
                                ),
                              ),
                            )
                      
                          ),
                    ),

                    const SizedBox(height: 15,),


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
                                if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                  context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedPrincess));
                    
                                context.read<SwipeBloc>().add(LoadUserAd(
                                userId: context.read<AuthBloc>().state.user!.uid, 
                                users: context.read<AuthBloc>().state.accountType!,
                                loadFor: LoadFor.adPrincess,
                                limit: 1
                                ));
                    
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                  Icon(LineIcons.crown, color: Colors.pink[300], size: 25, ),
                                SizedBox(width: 10,),
                                Text('Watch 10 Ads - Get 1 Princess  (${context.read<AdBloc>().state.adWatchedPrincess}/10) watched!', 
                                textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey), ),
                    
                                ],),
                              ),
                            )
                      
                          ),
                    ),

                    SizedBox(height: 15,),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                            
                            child: InkWell(
                              onTap: (){
                                if(context.read<AdBloc>().state.isLoadedRewardedAd){
                                  context.read<AdBloc>().add(const ShowRewardedAd(adType: AdType.rewardedQueen));
                                if(context.read<AdBloc>().state.adWatchedQueen == 20 ){
                                context.read<SwipeBloc>().add(LoadUserAd(
                                userId: context.read<AuthBloc>().state.user!.uid, 
                                users: context.read<AuthBloc>().state.accountType!,
                                loadFor: LoadFor.adQueen,
                                limit: 1
                                ));
                                }
                    
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(LineIcons.crown,color: Colors.amber,size: 25, ),
                                    SizedBox(width: 10,),
                                    Text('Watch 20 Ads - Get 1 Queen  (${context.read<AdBloc>().state.adWatchedQueen }/20) watched!', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey), ),
                    
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
    
    
                    
                    
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          onPressed: (){
                            showPrefesSheet(context: context);
                          },
                          backgroundColor: Colors.grey[400],
                          foregroundColor: Colors.grey[900],
                          child: Icon(Icons.settings),
                        ),
                      ),
                    )
                  ],
                
              ),
    );
  }





  void showPrefesSheet({required BuildContext context}) {
    var state = context.read<UserpreferenceBloc>().state as UserPreferenceLoaded;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
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
                        isDark ? state.userPreference.discoverBy ==DiscoverBy.habeshawelogic.index?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==DiscoverBy.habeshawelogic.index? Colors.grey[400]: Colors.white,
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
                                  state.userPreference.discoverBy! == DiscoverBy.habeshawelogic.index, 
                                  onChanged: (value){
                                    
                                    context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference.copyWith(discoverBy: DiscoverBy.habeshawelogic.index), users: context.read<AuthBloc>().state.accountType!, ));
                                    print(DiscoverBy.habeshawelogic.index);
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
                        color: isDark ? state.userPreference.discoverBy == DiscoverBy.preference.index?  Colors.grey[800] :Colors.grey[900]  : state.userPreference.discoverBy == DiscoverBy.preference.index? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Column(
                            children: [
                        
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Preference'),
                                    Switch(value: state.userPreference.discoverBy! == DiscoverBy.preference.index, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference.copyWith(discoverBy: DiscoverBy.preference.index), users: context.read<AuthBloc>().state.accountType!,  ));
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
                        color: isDark ? state.userPreference.discoverBy ==DiscoverBy.nearby.index?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==DiscoverBy.nearby.index? Colors.grey[400]: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Discover By - Nearby Matches'),
                                    Switch(value: state.userPreference.discoverBy! == DiscoverBy.nearby.index, 
                                    onChanged: (value){
                                      
                                      context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference.copyWith(discoverBy: DiscoverBy.nearby.index), users: context.read<AuthBloc>().state.accountType!,));
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

                      Card(
                      elevation: 2,
                      color: isDark ? state.userPreference.discoverBy == DiscoverBy.online.index?  Colors.grey :Colors.grey[900] : state.userPreference.discoverBy ==DiscoverBy.online.index? Colors.grey[400]: Colors.white,
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
                                Text('Discover By - Online Matches'),
                                Switch(value: state.userPreference.discoverBy == DiscoverBy.online.index , 
                                onChanged: (value){
                                  
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: DiscoverBy.online.index)));
                                  //isThereChange = true;
                                  Navigator.pop(context);
                                }),
                              ],
                            ),
                            Text('Online Matches gives you matches who is currently online the world.',
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