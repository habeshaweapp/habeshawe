import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';

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
    return BlocBuilder<UserpreferenceBloc, UserpreferenceState>(
      builder: (context, state) {
        if(state is UserPreferenceLoading){
          return Center(child: CircularProgressIndicator(),);
        }

        if(state is UserPreferenceLoaded){
          return WillPopScope(
            onWillPop: ()async{

              if(isThereChange == true){
                context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference, users: context.read<AuthBloc>().state.accountType!));
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
                    Text('Account Settings',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 16
                      ) 
                    ),
            
                    Card(
                      color: isDark ? cardColor : Colors.white,
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 10, bottom: 10,),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone Number'),
                            Text('${state.userPreference.phoneNumber} >'),
                          ],
                        ),
                      ),
                    ),
            
                    Text('Verify a Phone Number to help secure your account.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    ),
            
                    SizedBox(height: 25,),
            
                    Text('Discovery Settings',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 17,
                        //color: Colors.grey[800],
                      ) 
                    ),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference.discoverBy ==0?  cardColor :Colors.grey[900] : state.userPreference.discoverBy ==0? Colors.grey[400]: Colors.white,
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
                                Switch(value: state.userPreference.discoverBy == 0 , 
                                onChanged: (value){
                                  
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 0)));
                                  isThereChange = true;
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
                    Text('Going global will allow you to see people nearby and from around the world.',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                    ),
            
                    SizedBox(height: 20,),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference.discoverBy ==1?  cardColor :Colors.grey[900]  : state.userPreference.discoverBy ==1? Colors.grey[400]: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                      
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discover By - Preference'),
                                  Switch(value: state.userPreference.discoverBy! == 1, 
                                  onChanged: (value){
                                    
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 1)));
                                    isThereChange = true;
                                  }),
                                ],
                              ),
                              Text('You will get matches based on your preferences once in a day. your preference include all your profile information including age range that will probably will match with your choice and profile information.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                                          ),

                              SizedBox(height: 20,),


                              Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Age Range', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
                                Text('${state.userPreference.ageRange![0]} - ${state.userPreference.ageRange![1]}.')
                              ],
                            ),
                          ),
                          
                          AbsorbPointer(
                            absorbing: state.userPreference.discoverBy != 1,
                            child: RangeSlider(
                              max: 70,
                              min:18,
                              values: RangeValues(state.userPreference.ageRange![0].toDouble(),state.userPreference.ageRange![1].toDouble()), 
                              onChanged: (values){
                                context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.start.toInt(),values.end.toInt()])));
                                isThereChange = true;
                              }
                              ),
                          ),

                           // SizedBox(height: 10,),
                      
                      
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                           
                                  
                                  
                            AbsorbPointer(
                              absorbing: state.userPreference.discoverBy != 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                      
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Only show people in this range', style: Theme.of(context).textTheme.bodySmall, ),
                                Switch(value: state.userPreference.onlyShowInThisRange!, 
                                onChanged: (value){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(onlyShowInThisRange: value)));
                                  isThereChange = true;
                                }),
                              ],
                             ),
                             ),
                            ),


                             //SizedBox(height: 0,), 
                                  
                            AbsorbPointer(
                              absorbing: state.userPreference.discoverBy != 1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                      
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Only show people from my City\ncurrent city (${(context.read<ProfileBloc>().state as ProfileLoaded).user.countryCode}).', 
                                style: Theme.of(context).textTheme.bodySmall, ),
                                Switch(value: state.userPreference.onlyShowInThisRange!, 
                                onChanged: (value){
                                  context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(onlyShowInThisRange: value)));
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
            
                    SizedBox(height: 15,),
            
                    Card(
                      elevation: 2,
                      color: isDark ? state.userPreference.discoverBy ==2?  cardColor :Colors.grey[900] : state.userPreference.discoverBy ==2? Colors.grey[400]: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Discover By - Nearby Matches'),
                                  Switch(value: state.userPreference.discoverBy! == 2, 
                                  onChanged: (value){
                                    
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(discoverBy: 2)));
                                    isThereChange = true;
                                  }),
                                ],
                              ),
                              Text('find peoples nearby within 2km away from you. this method is free you can use it anytime of the day with out time limit if there are peoples near you they will appear.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                                          ),
                              Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Maximum Distance', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
                                  Text('${state.userPreference.maximumDistance}KM.')
                                ],
                              ),
                            ),
                              AbsorbPointer(
                                absorbing: state.userPreference.discoverBy != 2,
                                child: Slider(
                                value: state.userPreference.maximumDistance!.toDouble(), 
                                max: 2,
                                
                                divisions: 2,
                                onChanged: (value){
                                 context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(maximumDistance: value.toInt())));
                                 isThereChange = true;
                                }
                                                          ),
                              ),
                          ],
                        ),
                      ),
                    ),
          
                    //SizedBox(height: 15,),
            
            
            
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('HabeshaWe uses these preferences to suggest matches. Some match suggestions may not fall within your desired parameters.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[600]),
                      ),
                    ),
          
                    SizedBox(height: 20,),
          
                    Text('Show me on HabeshaWe',
                      style: TextStyle(
                       // fontWeight: FontWeight.bold,
                        fontSize: 17,
                        //color: Colors.grey[800],
                      ) 
                    ),
          
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                       // margin: EdgeInsets.only(top: 5, bottom: 5,),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Show me on HabeshaWe'),
                            Switch(
                              value: state.userPreference.showMeOnLomi!
                            , onChanged: (value){
                              context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(showMeOnLomi: value)));
                              isThereChange = true;
                            }),
                          ],
                        ),
                      ),
                    ),
          
                    SizedBox(height: 20,),
          
                    Text('Activity Status',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                       // color: Colors.grey[800],
                      ) 
                    ),
          
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Recently Active Status', style: TextStyle(fontSize: 17, color: Colors.grey)),
                            //SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Show Activity status'),
                                Switch(
                                  value: state.userPreference.recentlyActiveStatus!, 
                                  onChanged: (value){
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(recentlyActiveStatus: value)));
                                    isThereChange = true;
                                  })
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
          
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
                                  value: state.userPreference.onlineStatus!, 
                                  onChanged: (value){
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(onlineStatus: value)));
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
                        fontSize: 17,
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
                                Text('Show Distances in', style: TextStyle(fontSize: 17, color: Colors.grey)),
                                Text(state.userPreference.showDistancesIn!)
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
                                  isSelected: state.userPreference.showDistancesIn == 'km' ? [true,false]: [false,true],
                                  onPressed: (index) {
                                    context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(showDistancesIn: index == 0 ? 'km': 'mi')));
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
                        context.read<DatabaseRepository>().updateOnlinestatus(
                            userId: context.read<AuthBloc>().state.user!.uid, 
                            gender: context.read<AuthBloc>().state.accountType!, 
                            online: false
                             );
                        context.read<AuthBloc>().add(LogOut());
                        // context.read<ProfileBloc>().close();
                        // context.read<UserpreferenceBloc>().close();
                        Future.delayed(Duration(milliseconds: 300), (){
                             Navigator.pop(context); 
                        });
                        
                        // .then(
                        //   (value) => GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.splashRouteName)
                        //   );
          
                        //GoRouter.of(context).pushNamed(MyAppRouteConstants.splashRouteName);
                        //context.pop();
                        
                        
          
                      },
                    ),
          
                    SizedBox(height: 25,),
                    Center(
                      child: Text('version 1.0.0.3', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: isDark? Colors.teal: Colors.green)),
                    ),
                    SizedBox(height: 25,),
          
                    InkWell(
                      child: Card(
                        color: isDark ? cardColor : Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Delete Account'),
                          )
                        ),
                      ),
          
                      onTap: (){},
                    ),
          
          
          
            
            
            
            
            
            
            
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
}