import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';

import '../../../Blocs/UserPreference/userpreference_bloc.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../app_route_config.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    bool isThereChange = false;
    Color? cardColor = Colors.grey[900];
    bool isDark = context.read<ThemeCubit>().state.themeMode == ThemeMode.dark;
    return BlocBuilder<UserpreferenceBloc, UserpreferenceState>(
      builder: (context, state) {
        if(state is UserPreferenceLoading){
          return Center(child: CircularProgressIndicator(),);
        }

        if(state is UserPreferenceLoaded){
          return WillPopScope(
            onWillPop: ()async{

              if(isThereChange == true){
                context.read<UserpreferenceBloc>().add(EditUserPreference(preference: state.userPreference));
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
                        fontWeight: FontWeight.bold,
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
                        style: Theme.of(context).textTheme.bodySmall,
                    ),
            
                    SizedBox(height: 25,),
            
                    Text('Discovery Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        //color: Colors.grey[800],
                      ) 
                    ),
            
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5, bottom: 5,),
                        decoration: BoxDecoration(
                          //color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Global'),
                            Switch(value: state.userPreference.global!, 
                            onChanged: (value){
                              
                              context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(global: value)));
                              isThereChange = true;
                            }),
                          ],
                        ),
                      ),
                    ),
                    Text('Going global will allow you to see people nearby and from around the world.',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[600]),
                    ),
            
                    SizedBox(height: 20,),
            
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
                                Text('Maximum Distance', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
                                Text('${state.userPreference.maximumDistance}KM.')
                              ],
                            ),
                          ),
                          Slider(
                            value: state.userPreference.maximumDistance!.toDouble(), 
                            max: 100,
                            onChanged: (value){
                             context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(maximumDistance: value.toInt())));
                             isThereChange = true;
                            }
                          ),
            
            
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Only show people in this range'),
                            Switch(value: state.userPreference.onlyShowInThisRange!, 
                            onChanged: (value){
                              context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(onlyShowInThisRange: value)));
                              isThereChange = true;
                            }),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
            
                    SizedBox(height: 15,),
            
                    Card(
                      elevation: 2,
                      color: isDark ? cardColor : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Show Me', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(state.userPreference.showMe!),
                                Text('>')
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
          
                    SizedBox(height: 15,),
            
            
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
                                Text('Age Range', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
                                Text('${state.userPreference.ageRange![0]} - ${state.userPreference.ageRange![1]}.')
                              ],
                            ),
                          ),
                          
                          RangeSlider(
                            max: 70,
                            min:18,
                            values: RangeValues(state.userPreference.ageRange![0].toDouble(),state.userPreference.ageRange![1].toDouble()), 
                            onChanged: (values){
                              context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(ageRange: [values.start.toInt(),values.end.toInt()])));
                              isThereChange = true;
                            }
                            ),
            
            
                          Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Only show people in this range'),
                            Switch(
                              value: state.userPreference.onlyShowInThisRange!, 
                              onChanged: (value){
                                context.read<UserpreferenceBloc>().add(UpdateUserPreference(preference: state.userPreference.copyWith(onlyShowInThisRange: value)));
                                isThereChange = true;
                       
                            }),
                          ],
                        ),
                      ),
                        ],
                      ),
                    ),
            
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Lomi uses these preferences to suggest matches. Some match suggestions may not fall within your desired parameters.',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey[600]),
                      ),
                    ),
          
                    SizedBox(height: 20,),
          
                    Text('Show me on Lomi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
                            Text('Show me on Lomi'),
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
                            Text('Recently Active Status', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),),
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
                            Text('Online', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17),),
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
                        fontWeight: FontWeight.bold,
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
                                Text('Show Distances in', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17)),
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
                                              selectedColor: Colors.green,
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
                        context.read<AuthRepository>().signOut();
                        // .then(
                        //   (value) => GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.splashRouteName)
                        //   );
          
                        //GoRouter.of(context).pushNamed(MyAppRouteConstants.splashRouteName);
                        context.pop();
          
                      },
                    ),
          
                    SizedBox(height: 25,),
                    Center(
                      child: Text('version 1.0.0.0', style: Theme.of(context).textTheme.bodySmall),
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