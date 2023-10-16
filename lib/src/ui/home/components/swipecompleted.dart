import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';

import '../../../Blocs/AdBloc/ad_bloc.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/enums.dart';

class SwipeCompletedWidget extends StatelessWidget {
  const SwipeCompletedWidget({super.key, required this.state});

  final SwipeState state;

  @override
  Widget build(BuildContext context) {
    final now =DateTime.now();
    final remain  = now.difference(state.completedTime?? now);
    return  Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      
                children: [
                  Text('Thats it for today \ncome back Tomorrow!'),
                  Text(
                    '${remain.inHours}:${remain.inMinutes}:${remain.inSeconds} remains',
                    style: Theme.of(context).textTheme.bodyLarge,

                  ),

                  SizedBox(height: 25,),
                  ElevatedButton(
                    onPressed: (){
                      context.read<SwipeBloc>().add(LoadUsers(
                        userId: context.read<AuthBloc>().state.user!.uid, 
                        users: context.read<AuthBloc>().state.accountType!,
                        user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                        prefes: (context.read<UserpreferenceBloc>().state as UserPreferenceLoaded).userPreference
                        ));
                    }, 
                    child: Text('get Matches')
                    
                    ),

                    ElevatedButton(
                      onPressed: (){
                        if(context.read<AdBloc>().state.isLoadedRewardedAd){
                          context.read<AdBloc>().add(ShowRewardedAd());
                        
                          context.read<SwipeBloc>().add(LoadUserAd(
                          userId: context.read<AuthBloc>().state.user!.uid, 
                          users: context.read<AuthBloc>().state.accountType!,
                          discoverBy: DiscoverBy.online,
                          limit: 1
                          ));

                        }

                      }, 



                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Icon(Icons.video_collection),
                          Text('Watch 10 Ads to get 1 queen user (${context.read<AdBloc>().state.adWatchedQueen }-watched)')
                        ],),
                      )
                      ),

                  
                  ElevatedButton(
                      onPressed: (){
                        if(context.read<AdBloc>().state.isLoadedRewardedAd){
                          context.read<AdBloc>().add(ShowRewardedAd());
                        
                          context.read<SwipeBloc>().add(LoadUserAd(
                          userId: context.read<AuthBloc>().state.user!.uid, 
                          users: context.read<AuthBloc>().state.accountType!,
                          discoverBy: DiscoverBy.online,
                          limit: 1
                          ));

                        }

                        if(context.read<AdBloc>().state.reward!.amount >= 50){

                          context.read<SwipeBloc>().add(LoadUserAd(
                          userId: context.read<AuthBloc>().state.user!.uid, 
                          users: context.read<AuthBloc>().state.accountType!,
                          discoverBy: DiscoverBy.online,
                          limit: 1
                          ));


                        }

                      }, 
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          //mainAxisSize: MainAxisSize.min,
                          children: [
                          Icon(Icons.video_collection),
                          Text('Watch an Ad get 1 online user')
                        ],),
                      )
                      ),


                  
                  
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FloatingActionButton(
                        onPressed: (){
                          showPrefesSheet(context: context);
                        },
                        child: Icon(Icons.settings),
                      ),
                    ),
                  )
                ],
              
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