import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/Profile/profile.dart';
import 'package:lomi/src/ui/editProfile/editProfile.dart';
import 'package:lomi/src/ui/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../Blocs/UserPreference/userpreference_bloc.dart';
import '../../Data/Models/enums.dart';
import '../../Data/Models/user_model.dart';
import '../../Data/Models/userpreference_model.dart';
import '../../Data/Repository/Authentication/auth_repository.dart';
import '../verifyProfile/verifyprofile.dart';
import 'components/bottomprofile.dart';

class UserProfile extends StatelessWidget {
   UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    //bool isDark = Theme.of(context).brightness == ThemeMode.dark;
    showVerifyDialog(User user){
    return showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        //title: Text('Who are you'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        content: VerifyProfile(user:user),
        
      )
    );
  }
  
  //context.read<ThemeCubit>().state == ThemeMode.dark ;
  
    return Scaffold(
      //floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        child:  Icon(Icons.settings,
            color: isDark? Colors.white: Colors.black,
        ),
        heroTag: null,
        backgroundColor: isDark ? Colors.grey[800]: Colors.white,
        onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
      }),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          
          if(state is ProfileLoading){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          
          if(state is ProfileLoaded){
          return Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 4, color: isDark? Colors.teal : Colors.green
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) =>  Profile(user: state.user) ));
                              },
                              child: CircleAvatar(
                                backgroundImage:
                                    CachedNetworkImageProvider( 
                                      state.user.imageUrls[0]
                                      
                                      ),
                                radius: 80,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            onPressed: ()async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                              //context.read<DatabaseRepository>().getUsersBasedonPreference(state.user.id);
                              // var pin = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
                              // print(pin);
                              // final SharedPreferences prefes = await SharedPreferences.getInstance();
                              // prefes.setDouble('latitude', pin.latitude);
                              // prefes.setDouble('longitude', pin.longitude);
                              // var hash = MyGeoHash().geoHashForLocation(GeoPoint(pin.latitude, pin.longitude));
                              // print(hash); 
                             // context.read<SharedpreferenceCubit>().getMyLocation();

                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.green,
                                shape: StadiumBorder()),
                            child: Text("10% COMPLETE")),
                      ),
                      Positioned(
                        right: 0,
                        top: 30,
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfile()));
                           // Navigator.pushNamed(context, 'editProfile');
                            
                          },
                          backgroundColor: isDark ? Colors.grey[800]: Colors.white,
                          child: Icon(
                            Icons.edit,
                            color: isDark? Colors.white: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${state.user.name}, ${state.user.age}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18),
                  ),
                  // SizedBox(
                  //   width: 1,
                  // ),
                  IconButton(
                    
                    icon: state.user.verified == VerifiedStatus.queen.name ?
                      Icon(LineIcons.crown, color: Colors.amber, )
                    : Icon(state.user.verified == VerifiedStatus.verified.name ? Icons.verified_outlined : Icons.verified),
                    onPressed: (){
                     //context.read<UserpreferenceBloc>().add(EditUserPreference(preference: UserPreference(userId: state.user.id).copyWith(showMe: state.user.gender == 'Man' ? 'Women' : 'Man' )));

                      //Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyProfile()));
                      state.user.verified == VerifiedStatus.notVerified.name ?
                      showVerifyDialog(state.user)
                      :null;

                    },
                    )
                ],
              ),
              SizedBox(
                height: 50,
              ),
              //Color.fromARGB(255, 22, 22, 22)
              Expanded(
                child: Container(
                  color: isDark ? Color.fromARGB(255, 41, 41, 41): Colors.grey[200],
                  child: Column(
                    children: [
                      SizedBox(height: 20,),

                    
              Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.115,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                        color: isDark? Colors.grey[900]: null,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('0 Super Likes',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "GET MORE",
                                style: TextStyle(color: Colors.blue, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.115,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                        elevation: 4,
                        color: isDark? Colors.grey[900]: null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                Icons.electric_bolt,
                                color: Colors.purple,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('My Boosts', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "GET MORE",
                                style: TextStyle(color: Colors.blue, fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.115,
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: Card(
                        elevation: 4,
                        color: isDark? Colors.grey[900]: null,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(
                                LineIcons.lemon,
                                color: Colors.green,
                                size: 30,
                              ),
                              SizedBox(
                                height: 13,
                              ),
                              Text('Subscriptions',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey),),
                              // SizedBox(height: 5,),
                              //Text("GET MORE",style: TextStyle(color: Colors.blue),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: state.user.verified == VerifiedStatus.pending? 
                Container(
                  child: Column(
                    children: [
                      Text(
                        "Lomi Gold and Platinum \nNOT Avaiable",
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                            ),
                            onPressed: () {
                             // GoRouter.of(context).pushNamed(MyAppRouteConstants.settingsRouteName);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
                            // DatabaseRepository().createDemoUsers(UserModel.users);
                            },
                            child: Text(
                              "Buy me Coffee",
                            )),
                      )
                    ],
                  ),


                ): state.user.verified == null ?
                    SizedBox(
                      height: 250,
                      //width: 300,
                      child: PageView(
                        physics: const BouncingScrollPhysics(),
                        children:const [
                          PageViewItem(icon: LineIcons.crown,
                          color: Colors.amber,
                          title: 'Get Your Crown', 
                          description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                          buttonText: 'Apply  To Queen'
                          ),
                    
                          PageViewItem(icon: LineIcons.suitcase, 
                          color: Colors.black,
                          title: 'Get Your GentleMan Tag', 
                          description: 'Get verified and we will reveal your profile and if you stand out you will give you  gentlemans tag', 
                          buttonText: 'Apply  To Queen'
                          ),
                    
                          PageViewItem(icon: Icons.verified, 
                          color: Colors.blue,
                          title: 'Get Your Crown', 
                          description: 'Get verified and we will reveal your profile and if you stand out you will get Queen tag', 
                          buttonText: 'Apply  To Queen'
                          ),
                        ],
                      ),
                    )
                    : Container()
                
                ,
              ),

              
              Spacer(),
              // FloatingActionButton(
              //   onPressed: (){
              //     Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              //   },
              //   child: Icon(Icons.settings),
              //   ),
              ],
                  ),
                  )
                  )
            ],
          );
        }else{ return Text('somethisngs went wrong');}
        },
      ),
    );
  


  

  }
}
