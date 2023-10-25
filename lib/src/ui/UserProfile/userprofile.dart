import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
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
import '../payment/showPaymentDialog.dart';
import '../verifyProfile/verifyprofile.dart';
import 'components/bottomprofile.dart';
import 'components/gettag.dart';

class UserProfile extends StatelessWidget {
   UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    //bool isDark = Theme.of(context).brightness == ThemeMode.dark;
    showVerifyDialog(User user){
    return showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        //title: Text('Who are you'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))
        ),
        content: VerifyProfile(user:user, profileContext: context),
        
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
        heroTag: 'settings',
        backgroundColor: isDark ? Colors.grey[800]: Colors.white,
        onPressed: () async{


          // var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
          //                 String hash = MyGeoHash().geoHashForLocation(GeoPoint(position.latitude, position.longitude));
          //                 var placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
          //                 int rep = 0;
          //                 while(placeMark.isEmpty){
          //                   if(rep == 5)  break;
          //                   placeMark = await placemarkFromCoordinates(position.latitude, position.longitude);
          //                   rep ++;

          //                 }
          //                 if(context.mounted && placeMark.isNotEmpty ){
          //                   for(int i=0; i< UserModel.users.length; i++){
          //                     DatabaseRepository().completeOnboarding(placeMark: placeMark[0], user: UserModel.users[i].copyWith(location: [position.latitude,position.longitude]), isMocked: position.isMocked);
          //                   }
          //                   // context.read<OnboardingBloc>().add(CompleteOnboarding(placeMark: placeMark[0], user: state.user.copyWith(geohash: hash,location: [position.latitude, position.longitude], country: placeMark[0].country, countryCode: placeMark[0].isoCountryCode ), isMocked: position.isMocked));
          //                   // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          //                                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('done users are setup')));

          //                 }

          //                 if(placeMark.isEmpty){
          //                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('somethings not up...check your phone and Try Again')));
          //                 }


          Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  
                              BlocProvider.value(
                                value: context.read<UserpreferenceBloc>(),
                                child: BlocProvider.value(
                                value: context.read<ProfileBloc>(),
                                child:  Settings()
                              )
                              )
                              ));
          
       // Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
      }),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        
        builder: (context, state) {
          
          if(state is ProfileLoading){
            return const Center(
              child:  CircularProgressIndicator(),
            );
          }
          
          if(state is ProfileLoaded){
            Icon verifiedIcon =  Icon(Icons.verified_outlined);
            if(state.user.verified == VerifiedStatus.notVerified.name){
              verifiedIcon = const Icon(Icons.verified_outlined);
            }else if(state.user.verified == VerifiedStatus.verified.name){
              verifiedIcon = const Icon(Icons.verified, color: Colors.blue,);
            }else if(state.user.verified == VerifiedStatus.queen.name){
              verifiedIcon = const Icon(LineIcons.crown, color: Colors.amber,);
            }else if(state.user.verified == VerifiedStatus.princess.name){
              verifiedIcon = const Icon(LineIcons.crown, color: Colors.blue,);
            }else if(state.user.verified == VerifiedStatus.king.name){
              verifiedIcon = const Icon(LineIcons.crown, color: Colors.amber,);
            }else if(state.user.verified == VerifiedStatus.gentelmen.name){
              verifiedIcon = const Icon(LineIcons.suitcase, color: Colors.blue,);
            }
            
          return Column(
            children: [
              SizedBox(
                height: 30.h,
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
                              onLongPress: (){
                                Clipboard.setData(ClipboardData(text: 'Find me on Habeshawe id: ${state.user.id}'));
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('id generated! good luck...',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),)));
                              },
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  
                                  BlocProvider.value(
                                    value: context.read<ProfileBloc>() ,
                                    child: Profile(user: state.user, profileFrom: ProfileFrom.profile,)) 
                                ));
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
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  
                              BlocProvider.value(
                                value: context.read<ProfileBloc>(),
                                child: const EditProfile()
                              )
                              ));
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
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  
                              BlocProvider.value(
                                value: context.read<ProfileBloc>(),
                                child: const EditProfile()
                              )
                              ));
                            
                          },
                          heroTag: 'edit',
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
                height: 20.h,
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
                    icon: verifiedIcon,
                    onPressed: (){
                      state.user.verified == VerifiedStatus.notVerified.name?
                      showVerifyDialog(state.user): null;
                    },
                    )
                ],
              ),
              SizedBox(
                height: 40.h,
              ),
              //Color.fromARGB(255, 22, 22, 22)
              Expanded(
                child: Container(
                  color: isDark ? Color.fromARGB(255, 41, 41, 41): Colors.grey[200],
                  child: Column(
                    children: [
                      SizedBox(height: 20.h,),

                    
              Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProfileBox(
                      isDark: isDark, 
                      onTap: () => showPaymentDialog(context:context, paymentUi: PaymentUi.superlikes) ,
                      title: 'Super Likes',
                      superLikes: 0,
                      icon: Icons.star,
                      color: Colors.blue,
                      ),
                    SizedBox(
                      width: 7.w,
                    ),
                    ProfileBox(
                      isDark: isDark, 
                      title: 'My Boosts', 
                      icon: Icons.electric_bolt, 
                      onTap: ()=> showBoostsSheet(context, 2),
                      color: Colors.purple,

                      ),

                      SizedBox(width: 7.w,),

                      ProfileBox(
                        isDark: isDark,
                        title: 'Subscriptions',
                        icon: Icons.monetization_on,
                        color: Colors.green,
                        onTap: ()=> showPaymentDialog(context: context, paymentUi: PaymentUi.subscription),
                      ),

                   
                
                    
                    
                  ],
                ),
              ),
              Spacer(),
              GetTag(user: state.user,),

              
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


    void showBoostsSheet(BuildContext context, int boosts){
    
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return SizedBox(
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                padding: const EdgeInsets.only(left:15.0, top: 25, bottom: 15),
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
              ) ,
                ),
              
              Text('My Boosts',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
               ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Be a top profile everywhere in the world for 30 minutes to get more matches', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),

                  ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15),
                child: Row(
                  children: [
                    Icon(Icons.electric_bolt, color: Colors.purple, size: 35,),
                    SizedBox(width: 10,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start
                      ,
                      children: [
                        Text('Boosts'),
                        Text('0 left', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300), textAlign: TextAlign.start,)
                      ],
                    )
                  ],
                ),
              ),


              ElevatedButton(
                onPressed: (){
                  showPaymentDialog(context:context, paymentUi: PaymentUi.boosts);
                },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text('Get more Boosts',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
               ),
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: const StadiumBorder()
               ),
               )
              

            ],
          ),
        );
      }
      );
  }
}



class ProfileBox extends StatelessWidget {
  const ProfileBox({
    super.key,
    required this.isDark,
    required this.title,
    required this.icon,
    required this.onTap,
     this.superLikes,
     this.color
  });

  final bool isDark;
  final IconData icon;
  final String title;
  final void Function() onTap;
  final Color? color;

  final int? superLikes;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:75.h,
      // MediaQuery.of(context).size.height * 0.115,
      width: 
      //108.w,
      MediaQuery.of(context).size.width * 0.3,
      child: Card(
        color: isDark? Colors.grey[900]: null,
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: onTap,
          // (){
          //   showPaymentDialog(context:context, paymentUi: PaymentUi.superlikes);
          // },
          child: Padding(
            padding:  EdgeInsets.all(2.0.h),
            child: Column(
              children: [
                SizedBox(
                  height:title != 'Subscriptions'? 3.h:10.h,
                ),
                Icon(
                  icon,
                  color: color,
                  size: 20.h,
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text( superLikes != null? '$superLikes $title' : title
                  ,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey,fontSize: 10.sp),),
               title != 'Subscriptions'? SizedBox(
                  height: 5.h,
                ):SizedBox(),
                title != 'Subscriptions'?
                Text(
                  "GET MORE",
                  style: TextStyle(color: Colors.blue, fontSize: 10.sp),
                ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
