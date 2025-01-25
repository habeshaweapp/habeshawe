import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_geo_hash/geohash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/UpdateWallBloc/update_wall_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/Profile/profile.dart';
import 'package:lomi/src/ui/editProfile/editProfile.dart';
import 'package:lomi/src/ui/settings/settings.dart';
import 'package:lomi/src/updatewall.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown/slide_countdown.dart';

import '../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../Blocs/UserPreference/userpreference_bloc.dart';
import '../../Data/Models/enums.dart';
import '../../Data/Models/user_model.dart';
import '../../Data/Models/userpreference_model.dart';
import '../../Data/Repository/Authentication/auth_repository.dart';
import '../../Data/Repository/Remote/remote_config.dart';
import '../../Data/Repository/SharedPrefes/sharedPrefes.dart';
import '../payment/showPaymentDialog.dart';
import '../verifyProfile/verifyprofile.dart';
import 'components/bottomprofile.dart';
import 'components/gettag.dart';

class UserProfile extends StatelessWidget {
   const UserProfile({super.key});

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
      floatingActionButton: BlocBuilder<ThemeCubit, ThemeMode>(
      
        builder: (context, state) {
          isDark =state == ThemeMode.dark;
          return FloatingActionButton(
            child:  Icon(Icons.settings,
                color: isDark? Colors.grey[400]: Colors.black,
            ),
            heroTag: 'settings',
            backgroundColor: isDark ? Colors.grey[800]: Colors.white,
            onPressed: () async{
      
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
          });
        }
      ),
      body: BlocBuilder<ThemeCubit,ThemeMode>(
        builder: (context, state) {
          isDark = state == ThemeMode.dark;
          
          return BlocBuilder<ProfileBloc, ProfileState>(
            
            builder: (context, state) {
              
              if(state is ProfileLoading){
                return const Center(
                  child:  CircularProgressIndicator(),
                );
              }
              
              if(state is ProfileLoaded){
                Icon verifiedIcon =  Icon(Icons.verified_outlined,color: Colors.grey,);
                if(state.user.verified == VerifiedStatus.notVerified.name){
                  verifiedIcon = const Icon(Icons.verified_outlined, color: Colors.grey,);
                }else if(state.user.verified == VerifiedStatus.verified.name){
                  verifiedIcon = const Icon(Icons.verified, color: Colors.blue,);
                }else if(state.user.verified == VerifiedStatus.queen.name){
                  verifiedIcon = const Icon(LineIcons.crown, color: Colors.amber,);
                }else if(state.user.verified == VerifiedStatus.princess.name){
                  verifiedIcon = const Icon(LineIcons.crown, color: Colors.pink,);
                }else if(state.user.verified == VerifiedStatus.king.name){
                  verifiedIcon = const Icon(FontAwesomeIcons.crown, color: Colors.amber,);
                }else if(state.user.verified == VerifiedStatus.gentelmen.name){
                  verifiedIcon = const Icon(FontAwesomeIcons.userTie,size: 23, color: Colors.black,);
                }

                int percent = 0;
                if(state.user.imageUrls.length > 3){
                  percent = 40;
                }else{
                  percent = 20;
                }
                if(state.user.aboutMe != null && state.user.aboutMe != '') percent += 30;
                if(state.user.height !=null )percent += 5;
                if(state.user.education !=null&& state.user.education != '' )percent += 5;
                if(state.user.jobTitle !=null&& state.user.jobTitle != '' )percent += 5;
                if(state.user.company !=null&& state.user.company != '' )percent += 5;
                if(state.user.school !=null&& state.user.school != '' )percent += 5;
                if(state.user.livingIn !=null && state.user.livingIn != '')percent += 5;

                context.read<DatabaseRepository>().checkForChanges(user: state.user);
                if(state.user.fake == 'blocked09'){
                  context.read<UpdateWallBloc>().add(const ShutDownEvent(shut: Shuts.fake));
                }
                
              return Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  Center(
                    child: SizedBox(
                      height: 220.h,
                      width: 220.h,
                      child: Stack(
                        children: [
                          Center(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 4, color: isDark? Colors.teal : Colors.green,),
                                
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onLongPress: (){
                                    Clipboard.setData(ClipboardData(text: 'Find me on Habeshawe id: ${state.user.id}'));
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black38, content: Text('id generated! good luck...',style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),)));
                                  },
                                  onTap: (){
                                    var firt = SharedPrefes.getFirstLogIn();
                                    var back = SharedPrefes.inBackground();

                                    Navigator.push(context, MaterialPageRoute(builder: (ctx) =>  
                                      BlocProvider.value(
                                        value: context.read<ProfileBloc>() ,
                                        child: BlocProvider.value(
                                          value: context.read<UserpreferenceBloc>(),
                                          child:BlocProvider.value(value: context.read<SharedpreferenceCubit>(),
                                        child:
                                          Profile(user: state.user, profileFrom: ProfileFrom.profile,ctrx: context,)))) 
                                    ));
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        CachedNetworkImageProvider( 
                                          state.user.imageUrls[0]??'x',
                                          
                                          
                                          ),
                                    radius: 90.h,
                                    backgroundColor: !isDark?Colors.grey[200]: Colors.grey[800],
                                    
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
                                     foregroundColor:percent==100?null: Colors.grey,
                                    backgroundColor: percent==100?null: isDark? Colors.grey[900]: Colors.white,
                                    shape: StadiumBorder()),
                                child: Text("$percent% COMPLETE")),
                          ),
                          Positioned(
                            right: 0,
                            top: 30.h,
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
                                //size: ,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state.user.name}, ${state.user.age}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 18.sp),
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
                    height: 30.h,
                  ),
                  //Color.fromARGB(255, 22, 22, 22)
                  Expanded(
                    child: Container(
                      color: isDark ? Color.fromARGB(255, 41, 41, 41): Colors.grey[200],
                      child: Column(
                        children: [
                          SizedBox(height: 10.h,),

                        
                  Padding(
                    padding:  EdgeInsets.all(8.0.w),
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<PaymentBloc,PaymentState>(
                          builder: (context,state) {
                            return ProfileBox(
                              isDark: isDark, 
                              onTap: (){
                               // if(context.read<PaymentBloc>().state.productDetails.isNotEmpty){
                                  showPaymentDialog(context:context, paymentUi: PaymentUi.superlikes);
                               // }
                              },
                              title: 'Super Likes',
                              superLikes: state.superLikes,
                              icon: Icons.star,
                              color: Colors.blue,
                              );
                          }
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ProfileBox(
                          isDark: isDark, 
                          title: 'My Boosts', 
                          icon: Icons.electric_bolt, 
                          onTap: ()=> showBoostsSheet(context, 2),
                          color: Colors.purple,

                          ),

                          SizedBox(width: 10.w,),

                          ProfileBox(
                            isDark: isDark,
                            title: 'Subscriptions',
                            icon: Icons.diamond,
                            color: Colors.amber,
                            onTap: (){
                             // if(context.read<PaymentBloc>().state.productDetails.isNotEmpty){
                               showPaymentDialog(context: context, paymentUi: PaymentUi.subscription);
                             // }

                            }
                          ),

                       
                    
                        
                        
                      ],
                    ),
                  ),
                  Spacer(),
                  GetTag(user: state.user,ontap: (){showVerifyDialog(state.user);},),
                  
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
          );
        }
      ),
    );
  


  

  }


    void showBoostsSheet(BuildContext context, int boosts){
      final RemoteConfigService remoteConfig = RemoteConfigService();
    
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return SizedBox(
          height: 270.h,
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
               style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
               ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Be a top profile everywhere in the world for ${remoteConfig.boostTime()} minutes to get more matches', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300),

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
                        Text('${context.read<PaymentBloc>().state.boosts} left', style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300), textAlign: TextAlign.start,)
                      ],
                    ),
                    Spacer(flex: 3,),
                    context.read<PaymentBloc>().state.boostedTime == null?ElevatedButton(
                onPressed: ()async{
                  // var us = await context.read<DatabaseRepository>().getUserbyId('f78nRlbhlodY0h6u87HTV35RHNq1', 'women');
                  // context.read<PaymentBloc>().add(BoostMe(user: us ));
          
                  if(context.read<PaymentBloc>().state.boosts == 0){
                  if(context.read<PaymentBloc>().state.productDetails.isNotEmpty){
                    Navigator.pop(context);
                  showPaymentDialog(context:context, paymentUi: PaymentUi.boosts);
                  }
                  }else{
                    if(context.read<PaymentBloc>().state.boosts > 0){
                      context.read<PaymentBloc>().add(BoostMe(user: (context.read<ProfileBloc>().state as ProfileLoaded).user));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.black38, content: Text('You are boosted!', style: TextStyle(fontSize: 12.sp),)));
                      Navigator.pop(context);

                    
                    }

                  }
                },
               child: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text('Boost',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),),
               ),
               style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[400],
                shape: const StadiumBorder()
               ),
               ):
                                                  Padding(  
                                                          padding:  EdgeInsets.only(left:20.0.w),
                                                          child:  SlideCountdown(
                                                            duration: Duration(seconds: remoteConfig.boostTime()*60 - DateTime.now().difference(context.read<PaymentBloc>().state.boostedTime ??DateTime.now()).inSeconds),
                                                          
                                                          textStyle: TextStyle(fontSize: 12.sp, color: Colors.white),
                                                          padding: EdgeInsets.symmetric(horizontal: 7,vertical: 2),
                                                        
                                                          ),
                                                        ),

                                      Spacer(),


                  ],
                ),
              ),


              ElevatedButton(
                onPressed: (){
                 // if(context.read<PaymentBloc>().state.productDetails.isNotEmpty){
                    Navigator.pop(context);
                  showPaymentDialog(context:context, paymentUi: PaymentUi.boosts);
                 // }
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
      height:95.h,
       //MediaQuery.of(context).size.height * 0.115,
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
                  height:title != 'Subscriptions'? 5.h:15.h,
                ),
                Icon(
                  icon,
                  color: color,
                  size: 25.h,
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text( superLikes != null? '$superLikes $title' : title
                  ,style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey,fontSize: 11.sp),),
               title != 'Subscriptions'? SizedBox(
                  height: 5.h,
                ):SizedBox(),
                title != 'Subscriptions'?
                Text(
                  "GET MORE",
                  style: TextStyle(color: Colors.blue, fontSize: 12.sp),
                ):SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
