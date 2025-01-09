import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/dataApi/icons.dart';
import 'package:lomi/src/ui/payment/showPaymentDialog.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/SharedPrefes/sharedpreference_cubit.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Models/likes_model.dart';
import '../../../Data/Models/model.dart';
import '../../../Data/Models/tag_helper.dart';
import '../../../Data/Models/looking_for_datas.dart';
import '../../../Data/Repository/Database/database_repository.dart';
import '../../editProfile/editProfile.dart';
import '../../home/components/userdrag.dart';
import '../../itsAmatch/itsAmatch.dart';
import '../../onboarding/AfterRegistration/widgets/lookingforitem.dart';
import '../../report/report.dart';

class Body extends StatelessWidget {
  final User user;
  final ProfileFrom profileFrom;
  final Like? likedMeUser;
  final MatchEngine? matchEngine;
  final BuildContext ctrx;

   Body({Key? key, required this.user, required this.profileFrom,this.likedMeUser, this.matchEngine, required this.ctrx}) : super(key: key);

   Future<Position> getCurrentPosition()async{
    return await Geolocator.getCurrentPosition();
   }
   double calculateDistance(List<double> currentPosition, List<double> userPosition) {
    //Position currentPosition =  getCurrentPosition();
    return Geolocator.distanceBetween(currentPosition[0], currentPosition[1], userPosition[0], userPosition[1])/1000;
   }
   

  @override
  Widget build(BuildContext context)  {
    //var profileState = context.read<ProfileBloc>().state as ProfileLoaded;
    //profileState.user.location;    411.42, 843.42
    var size = MediaQuery.of(context).size;
    var intersts = ['startup', 'Progamming', 'coding', 'flutter', 'dart', 'aynalem', 'gete', 'jesus', 'tsinat', 'betbalew layi'];
    //
    //var km = await calculateDistance(user.location!);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    PageController pageController = PageController();
    bool isDart = context.read<ThemeCubit>().state == ThemeMode.dark;
    
    var myLocation = ctrx!.read<SharedpreferenceCubit>().state.myLocation;
    double? distanceD;
    int distance = 0;
    String km = ctrx!.read<UserpreferenceBloc>().state.userPreference!.showDistancesIn!;
    if(myLocation != null){
      distanceD = calculateDistance(myLocation, user.location!);
      
    if(km == 'mi'){
      distanceD = distanceD*0.62137;
      if(distanceD < 1){
        distance = 0;
      }else{
      distance = distanceD.round();
      }
      
    }else{
      if(distanceD < 1){
        distance = 0;
      }else{
      distance = distanceD.round();
      }
    }
    }
    // if(imgindex != null){
    //                             pageController.animateToPage(imgindex!.toInt(), duration: Duration(milliseconds: 300), curve: Curves.linear);
    //                           }
    
    return SafeArea(
      child: Stack(
        children: [
          
          CustomScrollView(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        slivers: [
                          SliverAppBar(
                            backgroundColor: Colors.transparent,
                            //collapsedHeight: 12,
                            //toolbarHeight: 28,
                            
                            //snap: true,
                            expandedHeight: 550,
                            stretch: true,
                            floating: true,
                            //onStretchTrigger: ()async{return true;},
                            flexibleSpace: FlexibleSpaceBar(
                              // stretchModes: <StretchMode> [
                              //   StretchMode.zoomBackground,
                              //   StretchMode.blurBackground,
                              // ],
                              background: SizedBox(
                          height: 550,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: [
                              PageView.builder(
                                physics: BouncingScrollPhysics(),
                                itemCount: user.imageUrls.length,
                                controller: pageController ,
                                itemBuilder: (context, index){
                                  
                                  return SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: CachedNetworkImage(
                                      imageUrl: user.imageUrls[index],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(strokeWidth: 2,)),
                                      errorWidget: (context, url,  error) {
                                        debugPrint(error.toString());
                                      //  if(error.statusCode == 403)
                                      //   {
                                          if(profileFrom == ProfileFrom.like || profileFrom == ProfileFrom.chat){
                                            context.read<DatabaseRepository>().changeMatchImage(
                                                userId: context.read<AuthBloc>().state.user!.uid, 
                                                userGender: context.read<AuthBloc>().state.accountType!,
                                                match:  {
                                                  'id': user.id,
                                                  'gender': user.gender,
                                                  'imageUrls':user.imageUrls
                                                }, 
                                                from:profileFrom == ProfileFrom.like? 'likes':'matches');
                                          }
                                        // }

                                        return Icon(Icons.error);

                                      } 
                                      )
                                   // Image.network(user.imageUrls[index], fit: BoxFit.cover,)
                                  );
    
                                }),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: LineIndicator(user: user, pageController: pageController)
                                ),
                            ],
                          ),
                        ),
                            ),
                          ),

                          

                         
    
                          SliverToBoxAdapter(
                            child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "${user.name}  ${user.age}", 
                                style: TextStyle(fontSize: 24, fontFamily: 'Proxima-Nova_Extrabold', fontWeight: FontWeight.bold,  ),
                                ),
                            ),
                            SizedBox(width: 5,),
                            user.online ==true? ClipOval(
                              child: Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(color: Colors.green),
                              ),
                              
                            ):const SizedBox(),
                            //Icon( Icons.verified, color: user.verified == 'verified'? Colors.blue: Colors.blue )
                          ],
                        ),
                        SizedBox(height: 10,),
                        (user.verified!=null && user.verified != VerifiedStatus.pending.name && user.verified != VerifiedStatus.notVerified.name) ? SizedBox(
                          child: Row(
                            children: [
                              //Icon(Icons.verified,color: Colors.blue, size:18,),
                              TagHelper.getTag(name: user.verified!, size: 16 ),
                              SizedBox(width: 7,),
                              Text(user.verified! ,style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300))
                            ],
                          ),
                        ):SizedBox(),
                      
                        SizedBox(height:user.verified!=null? 5:0,),
                        
               user.height !=null ? SizedBox(
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.ruler, size: 16,color:Colors.grey),
                              SizedBox(width: 7,),
                              Text('${user.height}cm',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),)
                              
                            ],
                          ),
                        ):SizedBox(),

                        SizedBox(height: user.height!=null?5:0,),

               (user.jobTitle !=null && user.jobTitle !='' ) || (user.company!=null && user.company!='')? SizedBox(
                          child: Row(
                            children: [
                              Icon(Icons.work, size: 18,color:Colors.grey),
                              SizedBox(width: 7,),
                              (user.jobTitle !=null && user.jobTitle !='' ) && (user.company!=null && user.company!='')? Text('${user.jobTitle} at ${user.company}',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),):
                              Text(user.jobTitle !=''?'${user.jobTitle}':'${user.company}',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),)
                              ,

                            ],
                          ),
                        ):SizedBox(),

                        
                      
                        // Container(
                        //   child: Text(
                        //     'Flutter developer at my own startup ',
                        //     style: TextStyle(fontSize: 14, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                        //     ),
                        // ),
                        SizedBox(height:(user.jobTitle !=null && user.jobTitle !='' ) || (user.company!=null && user.company!='')? 5:null,),
                        user.school!=null?SizedBox(
                          child: Row(
                            children: [
                              Icon(LineIcons.graduationCap, color: Colors.grey, size: 18,  ),
                              SizedBox(width: 7,),
                              Text(user.school!, style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),)
                            ],
                          ),
                        ):SizedBox(),
                        
                        SizedBox(height: user.school!=null? 5:0,),
                        SizedBox(
                          child: Row(
                            children: [
                              Icon(LineIcons.city,color: Colors.grey, size:18,),
                              SizedBox(width: 7,),
                              Text(user.livingIn != ''?user.livingIn??'${user.city}, ${user.country}':'${user.city}, ${user.country}',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300))
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),
                      

                      
                       profileFrom != ProfileFrom.profile?
                       myLocation != null?
                        Container(
                          child: 
                          Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.grey,size: 18,),
                              SizedBox(width: 7,),
                              Text(
                                
                                distance == 0? 'less than a $km away' :'${distance} $km away',
                                style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                                ),
                            ],
                          ),
                        ):SizedBox():const SizedBox(),
                      
                        SizedBox(height: 15,),
    
                        SizedBox(
                          //width: 200,
                          child: Card(
                            color: Colors.yellow.withOpacity(0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                 // TagHelper.getLookingFor(user.lookingFor??0)[0],
                                  lookingForIcons[user.lookingFor??0],
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Looking for', style: Theme.of(context).textTheme.bodySmall,),
                                      //Text(user.lookingFor?.replaceAll('\n', '') ?? 'Someone to love', style: Theme.of(context).textTheme.bodyLarge,)
                                      Text( lookignForOptions[user.lookingFor??0].replaceAll('\n', '') )
                                        //TagHelper.getLookingFor(user.lookingFor ?? 0 )[1].replaceAll('\n', ''))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                      
                        Container(
                          child: Text(
                                "About Me", 
                                style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', fontWeight: FontWeight.w400
                        ),
                                ),
                        ),
                      
                        SizedBox(height: 10,),
                      
                        Container(
                          width: size.width * 0.85,
                          child: Text(
                            user.aboutMe ?? '-',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13, fontWeight: FontWeight.w300)
                            
                           // TextStyle(fontFamily: 'Proxima-Nova-Bold',fontWeight: FontWeight.w300,),
                           //style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                            ),
                        ),
                        SizedBox(height: 30,),

                        const Divider(),
                      
                        Container(
                          child: Text(
                                "Interstes", 
                                style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', fontWeight: FontWeight.w400
                        ),
                                ),
                        ),
                      
                        SizedBox(height: 20,),
                      
                        Wrap(
                          spacing: 10,
                          runSpacing: 15,
                          children: List.generate(user.interests.length, (index) => 
                          Container(
                              //height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                //color: index.isEven ? Color(0xFF12B2B2).withOpacity(0.25) : Color(0xFF9933FF).withOpacity(0.25),
                                border: Border.all(width:1, color: Colors.grey)
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              child: Text(
                                user.interests[index], 
                              style: TextStyle(
                                fontWeight: FontWeight.w300, 
                                fontSize: 12
                                
                                )
                                ,),
                            ),
                          )
                        ),
                  
                  
                        SizedBox(height: 20,),

                        user.education !=null? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),

                             Container(
                              child: const Text(
                                    "Basics", 
                                    style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', fontWeight: FontWeight.w400
                            ),
                                    ),
                            ),
                            const SizedBox(height: 20,),

                            SizedBox(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(width: 1, color: Colors.grey)
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(LineIcons.graduationCap, size: 18 , color: Colors.grey),
                                    SizedBox(width: 5,),
                                    Text(
                                      user.education??'',
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ):SizedBox(),
                        
                      
                        // Container(
                        //   child: Text(
                        //         "Instagram", 
                        //         style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold',  fontWeight: FontWeight.w400
                        // ),
                        //         ),
                        // ),
                        SizedBox(height: 20,),
                        Divider(),
                       profileFrom != ProfileFrom.profile? SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: (){
                              showReportOptions(context, UserMatch(userId: user.id, name: user.name, gender: user.gender, imageUrls: user.imageUrls,  chatOpened: false, superLike: false));

                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Report ${user.name}', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18) ,textAlign: TextAlign.center, ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: Text('Don\'t worry-we won\'t tell them.', style: Theme.of(context).textTheme.bodySmall,),
                                )
                              ],
                            ),
                          ),
                        ):const SizedBox(),
                        const Divider(),

                        SizedBox(height: 50,),

                      ],
                    ),
                  ),
                          )
                        ],
                      ),


            

           (profileFrom != ProfileFrom.profile && profileFrom != ProfileFrom.chat)? Positioned(
            bottom: 20,
            //left: MediaQuery.of(context).size.width*0.4,
            right: MediaQuery.of(context).size.width*0.3,
            child: Row(
               // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    //radius: 100,
                    borderRadius: BorderRadius.circular(30),
                    onTap: (){
                      if(profileFrom == ProfileFrom.swipe){
                        Navigator.pop(context);
                        Future.delayed(Duration(milliseconds: 400), (){  
                             matchEngine?.currentItem?.nope();
                        });
                        
                      }

                      if(profileFrom == ProfileFrom.like ){
                        //
                        context.read<LikeBloc>().add(
                          DeleteLikedMeUser(
                            userId: context.read<AuthBloc>().state.user!.uid, 
                            users: context.read<AuthBloc>().state.accountType!, 
                            likedMeUserId: likedMeUser!.user.id
                            )
                        );
                        Navigator.pop(context);
                      }
                      if(profileFrom == ProfileFrom.search){
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark? Colors.grey[900]: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                    color:isDark? Colors.black.withOpacity(0.3): Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                                  )
                                ]
                              ),
                          
                              child: Center(
                                
                                child: Icon(Icons.close, color: Colors.red,),
                              ),
                          
                            ),
                  ),
            //SizedBox(width: 35,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                      //radius: 100,
                      borderRadius: BorderRadius.circular(30),
                      onTap: (){
                        if(profileFrom == ProfileFrom.swipe){
                          Navigator.pop(context);

                         // matchEngine?.currentItem?.superLike();
                          Future.delayed(Duration(milliseconds: 400), (){  
                             matchEngine?.currentItem?.superLike();
                        });
                        }

                        if(profileFrom == ProfileFrom.like ){
                          if(context.read<PaymentBloc>().state.superLikes >0){

                            context.read<LikeBloc>().add(LikeLikedMeUser(
                              user: (context.read<ProfileBloc>().state as ProfileLoaded).user, 
                              likedMeUser: likedMeUser!,
                              isSuperLike: true
                              ));
                              Navigator.pop(context);
                          }else{
                            showPaymentDialog(context: context, paymentUi: PaymentUi.superlikes);
                          }
                      }

                      if(profileFrom == ProfileFrom.search ){
                      
                        if(context.read<PaymentBloc>().state.superLikes >0){
                          context.read<SwipeBloc>().add(
                            SwipeRightEvent(
                              user: (context.read<ProfileBloc>().state as ProfileLoaded).user,  
                              matchUser: user
                              ));

                        Navigator.pop(context);
                        }else{
                            showPaymentDialog(context: context, paymentUi: PaymentUi.superlikes);
                          }
                       
                      }
                      },
                      child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:isDark? Colors.grey[900]: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                      color: isDark? Colors.black.withOpacity(0.3): Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                                    )
                                  ]
                                ),
                            
                                child: Center(
                                  // child: SvgPicture.asset(
                                  //   item_icons[1]['icon'],
                                  //   width: item_icons[1]['icon_size'],
                                    
                                  //   ),
                                  child: Icon(Icons.star, color: Colors.blue,),
                                ),
                            
                              ),
                    ),
            ),

            InkWell(
              borderRadius: BorderRadius.circular(0),
              onTap: (){
                if(profileFrom == ProfileFrom.swipe){
                // context.read<SwipeBloc>().add(
                // SwipeRightEvent(
                //   user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                //  matchUser: user
                //   ));

                Navigator.pop(context);
                
                  Future.delayed(Duration(milliseconds: 400), (){
                             //stackController?.next(swipeDirection: SwipeDirection.right); 
                             matchEngine?.currentItem?.like();
                        });

                }

                // if(profileFrom == ProfileFrom.like){
                //   context.read<LikeBloc>().add(LikeLikedMeUser(user: user, likedMeUser: likedMeUser!));
                // }
                if(profileFrom == ProfileFrom.like ){
                        context.read<LikeBloc>().add(LikeLikedMeUser(
                          user: (context.read<ProfileBloc>().state as ProfileLoaded).user, 
                          likedMeUser: likedMeUser!,
                          isSuperLike: false
                          ));

                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=> 
                                          BlocProvider.value(value: ctrx!.read<MatchBloc>(),
                                          child: ItsAMatch(user: likedMeUser! ))));
                      }

                if(profileFrom == ProfileFrom.search ){
                      

                          context.read<SwipeBloc>().add(
                            SwipeRightEvent(
                              user: (context.read<ProfileBloc>().state as ProfileLoaded).user,  
                              matchUser: user
                              ));

                        Navigator.pop(context);
                       
                      }

              },
              child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark? Colors.grey[900]: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isDark? Colors.black.withOpacity(0.3): Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                  )
                ]
              ),
                    
              child: Center(
                child: SvgPicture.asset(
                  item_icons[3]['icon'],
                  width: 20,
                  
                  ),
              ),
                    
                      ),
            ),
                ],
              ),
            
            ):profileFrom == ProfileFrom.profile?
            Positioned(
              bottom: 20,
              right: 30,
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
                            ),):const SizedBox(),

           // Icon(Icons.arrow_back),
            // IconButton(
            //   onPressed: (){
            //     Navigator.pop(context);
            //   }, 
            //   icon: Icon(Icons.arrow_back),
            //   )
            // Align(
            //         alignment: Alignment.topCenter,
            //         child: LineIndicator(user: user, pageController: pageController)
            //         ),
        ],
      ),
    );

  }

  void showReportOptions(BuildContext context, UserMatch userMatch){
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: ((ctx) {
        return SizedBox(
          height: 340,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Column(
                children: [
                  SizedBox(height: 20,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:30),
                    child: Text('Bloc and report this person',
                        style: TextStyle(fontSize: 18.sp),
                    ),
                    ),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Text('Don\'t worry, your feedback is anonymous and\n they won\'t know that you\'ve blocked or reported them.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                                ),
                    ),
                    SizedBox(height: 10,),
                    const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch, index: 8,name:'Fake Profile', ctx: context,) ));
                      },
                      child: Row(
                        children: [
                          Icon(Icons.person_off, color: Colors.green,),
                          SizedBox(width: 10,),
                          Text('Fake profile', style: TextStyle(fontSize: 13.sp))
                        
                        ]
                        ),
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch,index: 9,name:'Nudity or something sexually explicit', ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.chat_bubble, color: Colors.green),
                        SizedBox(width: 10),
                        Text('Nudity or something sexually explicit', style: TextStyle(fontSize: 13.sp))
                        
                        ]
                        ),
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch, index: 10,name:'Something that happened off HabeshaWe or in person',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.warning, color:Colors.green, ),
                        SizedBox(width: 10,),
                        Text('Something that happened off HabeshaWe\nor in person', style: TextStyle(fontSize: 13.sp) )
                        
                        ]
                        ),
                    ),
                  ),

                  const Divider(),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Report(matchedUser: userMatch, index: 11,name:'Their bio',ctx: context,) ));
                      },
                      child: Row(children: [
                        Icon(Icons.warning, color:Colors.green),
                        SizedBox(width: 10,),
                        Text('Their bio', style: TextStyle(fontSize: 13.sp))
                        
                        ]
                        ),
                    ),
                  ),
                

                  


                ]
              ),
            ],
          ),
        );
        
      }
    ));
  }



  }










  
