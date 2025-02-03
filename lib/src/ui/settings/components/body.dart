import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Remote/remote_config.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/UserPreference/userpreference_bloc.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../Data/Repository/Database/database_repository.dart';
import '../../../app_route_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThereChange = false;
    Color? cardColor = Color.fromARGB(255, 41, 39, 39);
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
     final RemoteConfigService remoteConfig = RemoteConfigService();
    return BlocBuilder<UserpreferenceBloc, UserPreferenceState>(
      builder: (context, state) {
        if(state.userPreferenceStatus == UserPreferenceStatus.loading){
          return const Center(child: CircularProgressIndicator(),);
        }

        if(state.userPreferenceStatus == UserPreferenceStatus.loaded){
          int remoteMax = remoteConfig.getNumbers()['settingsKmNearBy'];
          double remoteMaxAge = remoteConfig.getNumbers()['maxAge'].toDouble();
          int prefMax = state.userPreference!.maximumDistance!;
          if(prefMax > remoteMax){
            prefMax = remoteMax;

            context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(maximumDistance: remoteMax)));
            isThereChange = true;

          }
          double prefMaxAge = state.userPreference!.ageRange![1].toDouble();
          if(prefMaxAge > remoteMaxAge){
            remoteMaxAge = prefMaxAge;
          }
          return WillPopScope(
            onWillPop: ()async{

              if(isThereChange == true){
                context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference!, users: context.read<AuthBloc>().state.accountType!));
              }
              return true;

            },
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: context.read<ThemeCubit>().state == ThemeMode.light ? Colors.grey[100] : Colors.transparent,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Account Settings',
                    //   style: TextStyle(
                    //     //fontWeight: FontWeight.bold,
                    //     fontSize: 16
                    //   ) 
                    // ),
            
                    // Card(
                    //   color: isDark ? cardColor : Colors.white,
                    //   elevation: 2,
                    //   child: Container(
                    //     padding: EdgeInsets.all(10),
                    //     margin: EdgeInsets.only(top: 10, bottom: 10,),
                    //     decoration: BoxDecoration(
                    //       //color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text('Phone Number'),
                    //         Text('${state.userPreference!.phoneNumber}'),
                    //       ],
                    //     ),
                    //   ),
                    // ),
            
                    // Text('Verify a Phone Number to help secure your account.',
                    //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    // ),
            
                    // SizedBox(height: 5,),
            
                    Text('Discovery Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        //color: Colors.grey[800],
                      ) 
                    ),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference!.discoverBy == DiscoverBy.habeshawelogic.index ?  cardColor :Colors.grey[900] : state.userPreference!.discoverBy == DiscoverBy.habeshawelogic.index? Colors.grey[400]: Colors.white,
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
                                Switch(value: state.userPreference!.discoverBy == DiscoverBy.habeshawelogic.index , 
                                onChanged: (value){
                                  
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.habeshawelogic.index)));
                                  isThereChange = true;
                                }),
                              ],
                            ),
                            Text('HabeshaWe algorithm gives you the best profiles who is rated beautiful Habesha Matches around the world.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600],fontSize: 11.sp),
                    ),
                          ],
                        ),
                      ),
                    ),
                    // Text('Going global will allow you to see people nearby and from around the world.',
                    //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    // ),
            
                    SizedBox(height: 20,),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference!.discoverBy == DiscoverBy.preference.index?  cardColor :Colors.grey[900]  : state.userPreference!.discoverBy == DiscoverBy.preference.index? Colors.grey[400]: Colors.white,
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
                                    
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.preference.index)));
                                    isThereChange = true;
                                  }),
                                ],
                              ),
                              Text('You will get matches based on your preferences once in a day. your preference include all your profile information including age range that will probably will match with your choice and profile information.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600],fontSize: 11.sp),
                                          ),

                              SizedBox(height: 20,),


                              Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Age Range', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17.sp)),
                                Text('${state.userPreference!.ageRange![0]} - ${state.userPreference?.ageRange![1]}.')
                              ],
                            ),
                          ),
                          
                          AbsorbPointer(
                            absorbing: state.userPreference?.discoverBy != DiscoverBy.preference.index,
                            child: RangeSlider(
                              max: remoteMaxAge,
                              min:18,
                              divisions: 60-18,
                              values: RangeValues(state.userPreference!.ageRange![0].toDouble(),state.userPreference!.ageRange![1].toDouble()), 
                              // onChangeStart: (values) {
                              //   if(values.end - values.start <=10){
                              //     context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.start.toInt(),values.end.toInt()])));
                              //   }else{
                              //   context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.start.toInt(),values.start.toInt() +10])));
                              //   }
                              //   isThereChange = true;
                              // },
                              // onChangeEnd: (values){
                              //   if(values.end - values.start <=10){
                              //     context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.start.toInt(),values.end.toInt()])));
                              //   }else{
                              //     context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.end.toInt()-10,values.end.toInt()])));

                              //   }
                              //   isThereChange = true;

                              // },
                              

                              onChangeEnd: (value) {
                                // var diff = value.end- value.start;
                                // if(diff <=10 ){
                                //   context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [value.start.toInt(),value.end.toInt()])));

                                // }
                                // if(diff >10 && value.end - state.userPreference!.ageRange![1]==0){
                                //   context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [value.start.toInt(),value.start.toInt()+10])));


                                // }
                                // else if(diff >10 &&value.start - state.userPreference!.ageRange![0]==0){
                                //   context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [value.end.toInt()-10,value.end.toInt() ])));

                                // }
                                
                              },
                              


                              onChanged: (values){
                                var end = values.end - values.start;
                              
                                if(end <=10){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [values.start.toInt(),values.end.toInt()])));
                                }else{
                                  if(state.userPreference!.ageRange![1] != values.end.toInt()){
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [values.end.toInt()-10,values.end.toInt()])));
                                  }else{
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(ageRange: [values.start.toInt(),values.start.toInt()+10])));

                                  }
                                }

                                
                                isThereChange = true;
                              }
                              ),
                          ),

                           // SizedBox(height: 10,),
                      
                      
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                           
                                  
                                  
                            AbsorbPointer(
                              absorbing: state.userPreference!.discoverBy != DiscoverBy.preference.index,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                      
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Only show people from my Country\ncountry - ${(context.read<ProfileBloc>().state as ProfileLoaded).user.country}.',  
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp), ),
                                Switch(value: state.userPreference!.onlyShowFromMyCountry!, 
                                onChanged: (value){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(onlyShowFromMyCountry: value)));
                                  isThereChange = true;
                                }),
                              ],
                             ),
                             ),
                            ),


                             //SizedBox(height: 0,), 
                                  
                            AbsorbPointer(
                              absorbing: state.userPreference!.discoverBy != DiscoverBy.preference.index,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                      
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Only show people from my City\ncurrent city - ${(context.read<ProfileBloc>().state as ProfileLoaded).user.city}.', 
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp), ),
                                Switch(value: state.userPreference!.onlyShowFromMyCity??false, 
                                onChanged: (value){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(onlyShowFromMyCity: value, onlyShowFromMyCountry: value)));
                                  isThereChange = true;
                                }),
                              ],
                             ),
                             ),
                            ),

                            AbsorbPointer(
                              absorbing: state.userPreference!.discoverBy != DiscoverBy.preference.index,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                      
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Only show Recently-Active matches', 
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 11.sp), ),
                                Switch(value: state.userPreference!.onlyShowOnlineMatches??false, 
                                onChanged: (value){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(onlyShowOnlineMatches: value)));
                                  isThereChange = true;
                                }),
                              ],
                             ),
                             ),
                            ),
                            // Positioned(
                            //   left: 5,
                            //   child: Text(
                            //     'current city (${(context.read<ProfileBloc>().state as ProfileLoaded).user.country}).',
                            //     textAlign: TextAlign.left,
                            //     style: Theme.of(context).textTheme.bodySmall,
                            //     ),
                            // )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('HabeshaWe uses these preferences to suggest matches. Some match suggestions may not fall within your desired parameters.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600],fontSize: 11.sp),
                      ),
                    ),
            
                    SizedBox(height: 15,),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference!.discoverBy == DiscoverBy.nearby.index ?  cardColor :Colors.grey[900] : state.userPreference!.discoverBy == DiscoverBy.nearby.index ? Colors.grey[400]: Colors.white,
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
                                    
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.nearby.index)));
                                    isThereChange = true;
                                  }),
                                ],
                              ),
                              Text('find peoples nearby, within ${remoteConfig.getNumbers()['settingsKmNearBy']}-km from you.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600],fontSize: 11.sp),
                                          ),
                              Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Maximum Distance', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17.sp)),
                                  Text('${state.userPreference!.maximumDistance}KM.')
                                ],
                              ),
                            ),
                              AbsorbPointer(
                                absorbing: state.userPreference!.discoverBy != DiscoverBy.nearby.index,
                                child: Slider(
                                value: prefMax .toDouble(), 
                                max: (remoteConfig.getNumbers()['settingsKmNearBy'] as int).toDouble(),
                                
                                divisions: remoteConfig.getNumbers()['settingsKmNearBy'],
                                onChanged: (value){
                                 context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(maximumDistance: value.toInt())));
                                 isThereChange = true;
                                }
                                                          ),
                              ),
                          ],
                        ),
                      ),
                    ),
          
                    //SizedBox(height: 15,),
            
            
            
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text('HabeshaWe uses these preferences to suggest matches. Some match suggestions may not fall within your desired parameters.',
                    //       style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    //   ),
                    // ),
          
                    // SizedBox(height: 20,),
          
                    // Text('Show me on HabeshaWe',
                    //   style: TextStyle(
                    //    // fontWeight: FontWeight.bold,
                    //     fontSize: 17,
                    //     //color: Colors.grey[800],
                    //   ) 
                    // ),


                    
                    
            
                    // SizedBox(height: 20,),


                    // Card(
                    //   elevation: 2,
                    //   color: isDark ? state.userPreference!.discoverBy == DiscoverBy.online.index?  cardColor :Colors.grey[900] : state.userPreference!.discoverBy == DiscoverBy.online.index? Colors.grey[400]: Colors.white,
                    //   child: Container(
                    //     padding: EdgeInsets.all(10),
                    //     margin: EdgeInsets.only(top: 5, bottom: 5,),
                    //     decoration: BoxDecoration(
                    //       //color: Colors.white,
                    //     ),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                            
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text('Discover By - Online Matches'),
                    //             Switch(value: state.userPreference!.discoverBy == DiscoverBy.online.index , 
                    //             onChanged: (value){
                                  
                    //               context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(discoverBy: DiscoverBy.online.index)));
                    //               isThereChange = true;
                    //             }),
                    //           ],
                    //         ),
                    //         Text('Online Matches gives you matches who is currently online the world.',
                    //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    // ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // Text('Going global will allow you to see people nearby and from around the world.',
                    //     style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    // ),
            
                     SizedBox(height: 20,),

          
                    // Card(
                    //   elevation: 2,
                    //   color: isDark ? cardColor : Colors.white,
                    //   //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    //   child: Container(
                    //     padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                    //    // margin: EdgeInsets.only(top: 5, bottom: 5,),
                    //     decoration: BoxDecoration(
                    //       //color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Text('Show me on HabeshaWe'),
                    //         Switch(
                    //           value: state.userPreference.showMeOnLomi!
                    //         , onChanged: (value){
                    //           context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(showMeOnLomi: value)));
                    //           isThereChange = true;
                    //         }),
                    //       ],
                    //     ),
                    //   ),
                    // ),
          
                    SizedBox(height: 20,),
          
                    Text('Activity Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                       // color: Colors.grey[800],
                      ) 
                    ),
          
                    // Card(
                    //   elevation: 2,
                    //   color: isDark ? cardColor : Colors.white,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(15.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Recently Active Status', style: TextStyle(fontSize: 17, color: Colors.grey)),
                    //         //SizedBox(height: 10,),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Text('Show Activity status'),
                    //             Switch(
                    //               value: state.userPreference.recentlyActiveStatus!, 
                    //               onChanged: (value){
                    //                 context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(recentlyActiveStatus: value)));
                    //                 isThereChange = true;
                    //               })
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
          
                    SizedBox(height: 10,),
          
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Online', 
                            style: TextStyle(fontSize: 17, color: Colors.grey)
                            //Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),
                            ),
                           // SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Show Online status'),
                                Switch(
                                  value: state.userPreference!.onlineStatus!, 
                                  onChanged: (value){
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(onlineStatus: value)));
                                    if(!value){
                                    
                                      context.read<DatabaseRepository>().updateOnlinestatus(
                                      userId: context.read<AuthBloc>().state.user!.uid, 
                                      gender: context.read<AuthBloc>().state.accountType!, 
                                      online: false,
                                      showstatus: false
                                      );
                                    }else{
                                      context.read<DatabaseRepository>().updateOnlinestatus(
                                      userId: context.read<AuthBloc>().state.user!.uid, 
                                      gender: context.read<AuthBloc>().state.accountType!, 
                                      online: true,
                                      showstatus: true
                                      );

                                    }
                                    isThereChange = true;
                                  }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
          
                    SizedBox(height: 25,),
          
                    Text('App Settings',
                      style: TextStyle(
                       // fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                       
                        //color: Colors.grey[800],
                      ) 
                    ),
          
                    
          
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Show Distances in', 
                                style: TextStyle(fontSize: 17.sp, color: Colors.grey)
                                ),
                                Text(state.userPreference!.showDistancesIn!)
                              ],
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width*0.6,
                              child: Center(
                                child: ToggleButtons(
                                  children: [
                                    SizedBox(width: 100,child: Text('KM.', textAlign: TextAlign.center,)),
                                    SizedBox(width: 100,child: Text('MI.', textAlign: TextAlign.center,)),
                                  ], 
                                  isSelected: state.userPreference!.showDistancesIn == 'km' ? [true,false]: [false,true],
                                  onPressed: (index) {
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference!.copyWith(showDistancesIn: index == 0 ? 'km': 'mile')));
                                    isThereChange = true;
                                  },
                                  //borderRadius: BorderRadius.all(Radius.circular(30),),
                                              //selectedBorderColor: Colors.green,
                                              selectedColor: isDark? Colors.teal: Colors.green,
                                              //fillColor: Colors.white,
                                              //borderWidth: ,
                                  ),
                              ),
                            ),
                          )
            
            
                          
                        ],
                      ),
                    ),
          
                    SizedBox(height: 75,),
          
                    InkWell(
                      child: Card(
                        color: isDark ? cardColor : Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Logout'),
                          )
                        ),
                      ),
          
                      onTap: () {
                        //context.read<AuthRepository>().signOut();
                        // context.read<DatabaseRepository>().updateOnlinestatus(
                        //     userId: context.read<AuthBloc>().state.user!.uid, 
                        //     gender: context.read<AuthBloc>().state.accountType!, 
                        //     online: false
                        //      );
                        showDialog(
                          context: context, 
                          builder: (ctx)=> AlertDialog(
                            title: Text('Log Out?'),
                            actions: [
                              TextButton(
                                onPressed: (){
                                  Navigator.pop(context);
                                }, 
                                child: Text('Cancel')
                                ),
                              
                              TextButton(
                                onPressed: (){
                                  context.read<AuthBloc>().add(LogOut());
                                  Future.delayed(Duration(milliseconds: 400), (){
                                    Navigator.pop(context); 
                                    
                                });
                                  //Navigator.pop(context);
                                  Future.delayed(Duration(milliseconds: 900), (){
                                    Navigator.pop(context); 
                                    
                                });
                                  
                                }, 
                                child: Text('Log out', style: TextStyle(color: Colors.grey),)
                                )
                            ],

                          )
                          );

                            
                      },
                    ),
          
                    SizedBox(height: 25,),
                    Center(
                      child: Text('version 1.0.0.2', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isDark? Colors.teal: Colors.green,fontSize: 11.sp)),
                    ),
                    SizedBox(height: 25,),
          
          (remoteConfig.showDeleteAccount() || state.userPreference!.showDelete)?
                    InkWell(
                      onTap: (){
                        showDialog(
                          context: context, 
                          builder: (ctx){
                            return AlertDialog(
                              title: Text('Delete Account'),
                              content: SizedBox(
                                height: 300,
                                width: MediaQuery.of(context).size.width*0.95,
                                child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Please select areason for deleting\nyour account', style: TextStyle(fontSize: 13.sp, color:Colors.grey), ),
                                      const SizedBox(height: 15,),
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          confirmDelete(context, 'FOUND/IN A RELATIONSHIP');
                                        },
                                         
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [Icon(FontAwesomeIcons.heartPulse ,color:Colors.black),SizedBox(width: 5,), Text('FOUND/IN A RELATIONSHIP', textAlign: TextAlign.start, style:TextStyle( color: Colors.black) )],)
                                        ),
                                
                                      TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          confirmDelete(context, 'BILLING ISSUE');
                                        },
                                         
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [Icon(Icons.money_off_csred, color: Colors.black ), Text('BILLING ISSUE',style:TextStyle( color: Colors.black))],)
                                        ),
                                
                                        TextButton(
                                        onPressed: (){
                                          Navigator.pop(context);
                                          confirmDelete(context, 'DISSATISFIED WITH SERVICE');},
                                         
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [Icon(LineIcons.neutralFace, color:Colors.black), Text('DISSATISFIED WITH SERVICE',style:TextStyle( color: Colors.black))],)
                                        ),
                                        TextButton(
                                          
                                        onPressed: (){
                                          Navigator.pop(context);
                                          confirmDelete(context, 'OTHER');},
                                         
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [Text('OTHER', textAlign: TextAlign.right,style:TextStyle( color: Colors.black))],)
                                        ),
                                        TextButton(
                                        onPressed: (){Navigator.pop(context);},
                                         
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [ Text('CANCEL',style:TextStyle( color: Colors.black))],)
                                        ),
                                
                                    ],
                                  ),
                                ),
                              ) ,
                            );
                          }
                          );
                      },
                      child: Card(
                        color: isDark ? cardColor : Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Delete Account'),
                          )
                        ),
                      ),
          
                      
                    ):const SizedBox(),
          
          
          
            
            
            
            
            
            
            
                  ],
                ),
              ),
            ),
          );

        }else{
          return Text('something went wrong...');

        }
      },
    );
  }

  void confirmDelete(BuildContext context, String reason){
    showDialog(context: context, 
    builder: (ctx)=> AlertDialog(
      title: Text('Are you sure?', ),
      content: Container(
        width: MediaQuery.of(context).size.width*0.95,
        child: Text('Deleting your profile to create a new\naccount may affect who you see on\nthe platform, and we want you to have\nthe best experience possible.',style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, color: Colors.grey),)),

      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);

                bekaDeltew(context, reason);
          },
          child: Text('DELETE ACCOUNT', style: TextStyle(color: Colors.grey),),
        ),
        TextButton(
          onPressed: (){
            Navigator.pop(context);

          },
          child: Text('CANCEL', ),
        ),
      ],
      actionsOverflowDirection: VerticalDirection.down ,
    ),
    
    );
  }

  void bekaDeltew(BuildContext context, String reason){
    TextEditingController ctr = TextEditingController();
    showDialog(context: context, 
    builder: (ctx)=> AlertDialog(
      title: Text('Delete account?'),
      content: SizedBox(
        height: 125,
        width: MediaQuery.of(context).size.width*0.95,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('This action cannot be undone', style: TextStyle(color: Colors.grey, fontSize: 13.sp),),
            SizedBox(height: 15,),
            Text('Type \"delete\" to confirm', style: TextStyle(color: Colors.grey, fontSize: 12.sp),),
            
            TextField(
              controller: ctr,
            ),
            Text('*you may be redirected to login again, to complete deletion.', style: TextStyle(color: Colors.grey, fontSize: 10.sp),),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          },
          child: Text('CANCEL'),
          ),

        TextButton(
          onPressed: (){
            if(ctr.text == 'delete'){
              context.read<AuthBloc>().add(DeleteAccount(reason: reason));
              Navigator.pop(context);
              Navigator.pop(context);
              
            }
          },
          child: Text('CONFIRM', style: TextStyle(color: Colors.grey),),
          ),
      ],
    )
    );
  }
}