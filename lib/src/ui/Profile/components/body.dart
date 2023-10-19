import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/dataApi/icons.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/SharedPrefes/sharedpreference_cubit.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Data/Models/enums.dart';
import '../../../Data/Models/likes_model.dart';
import '../../../Data/Models/tag_helper.dart';
import '../../../Data/Models/user.dart';
import '../../home/components/userdrag.dart';
import '../../onboarding/AfterRegistration/widgets/lookingforitem.dart';

class Body extends StatelessWidget {
  final User user;
  final ProfileFrom profileFrom;
  final Like? likedMeUser;
  final MatchEngine? matchEngine;

   Body({Key? key, required this.user, required this.profileFrom,this.likedMeUser, this.matchEngine}) : super(key: key);

   Future<Position> getCurrentPosition()async{
    return await Geolocator.getCurrentPosition();
   }
   int calculateDistance(Position currentPosition, List<double> userPosition) {
    //Position currentPosition =  getCurrentPosition();
    return Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, userPosition[0], userPosition[1])~/1000;
   }
   

  @override
  Widget build(BuildContext context)  {
    var profileState = context.read<ProfileBloc>().state as ProfileLoaded;
    //profileState.user.location;
    var size = MediaQuery.of(context).size;
    var intersts = ['startup', 'Progamming', 'coding', 'flutter', 'dart', 'aynalem', 'gete', 'jesus', 'tsinat', 'betbalew layi'];
    //
    //var km = await calculateDistance(user.location!);
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    PageController pageController = PageController();
    bool isDart = context.read<ThemeCubit>().state == ThemeMode.dark;
    int distance = calculateDistance(context.read<SharedpreferenceCubit>().state.myLocation!, user.location!);
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
                                      errorWidget: (context, url, error) => Icon(Icons.error_outline_sharp),
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
                        user.verified!=null? SizedBox(
                          child: Row(
                            children: [
                              //Icon(Icons.verified,color: Colors.blue, size:18,),
                              TagHelper.getTag(name: user.verified!, size: 20),
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

               user.jobTitle !=null || user.company!=null? SizedBox(
                          child: Row(
                            children: [
                              Icon(Icons.work, size: 18,color:Colors.grey),
                              SizedBox(width: 7,),
                              user.jobTitle !=null && user.company!=null? Text('${user.jobTitle} at ${user.company}',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),):
                              Text(user.jobTitle !=null?'${user.jobTitle}':'${user.company}',style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),)
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
                        SizedBox(height: 5,),
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
                              Icon(Icons.home,color: Colors.grey, size:18,),
                              SizedBox(width: 7,),
                              Text(user.country!,style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300))
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),
                      

                      
                       profileFrom != ProfileFrom.profile? Container(
                          child: 
                          Row(
                            children: [
                              Icon(Icons.location_pin, color: Colors.grey,size: 18,),
                              SizedBox(width: 7,),
                              Text(
                                
                                distance == 0? 'less than a km away' :'${distance}km away',
                                style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                                ),
                            ],
                          ),
                        ):SizedBox(),
                      
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
                                  TagHelper.getLookingFor(user.lookingFor!)[0],
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Looking for', style: Theme.of(context).textTheme.bodySmall,),
                                      //Text(user.lookingFor?.replaceAll('\n', '') ?? 'Someone to love', style: Theme.of(context).textTheme.bodyLarge,)
                                      Text( TagHelper.getLookingFor(user.lookingFor ?? 0 )[1].replaceAll('\n', ''))
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
                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: (){

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
                        ),
                        const Divider(),

                        SizedBox(height: 50,),

                      ],
                    ),
                  ),
                          )
                        ],
                      ),


            

            Positioned(
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

                if(profileFrom == ProfileFrom.like){
                  context.read<LikeBloc>().add(LikeLikedMeUser(user: user, likedMeUser: likedMeUser!));
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
            
            ),

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
  }










  
