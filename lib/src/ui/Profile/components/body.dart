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
import 'package:lomi/src/dataApi/icons.dart';

import '../../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../../Blocs/SwipeBloc/swipebloc_bloc.dart';
import '../../../Data/Models/user.dart';

class Body extends StatelessWidget {
  final User user;
   Body({Key? key, required this.user}) : super(key: key);

   Future<Position> getCurrentPosition()async{
    return await Geolocator.getCurrentPosition();
   }
   int calculateDistance(GeoPoint currentPosition, GeoPoint userPosition) {
    //Position currentPosition =  getCurrentPosition();
    return Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, userPosition.latitude, userPosition.longitude)~/1000;
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
                            toolbarHeight: 0,
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
                          child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: user.imageUrls.length,
                            itemBuilder: (context, index){
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: CachedNetworkImage(
                                  imageUrl: user.imageUrls[index],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => Icon(Icons.error_outline_sharp),
                                  )
                               // Image.network(user.imageUrls[index], fit: BoxFit.cover,)
                              );
    
                            }),
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
                                "${user.name},  ${user.age}", 
                                style: TextStyle(fontSize: 24, fontFamily: 'Proxima-Nova_Extrabold', fontWeight: FontWeight.bold),
                                ),
                            ),
                            SizedBox(width: 10,),
                            ClipOval(
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(color: Colors.green),
                              ),
                              
                            )
                          ],
                        ),
                      
                        SizedBox(height: 10,),
                      
                        Container(
                          child: Text(
                            'Flutter developer at my own startup ',
                            style: TextStyle(fontSize: 14, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                            ),
                        ),
                        SizedBox(height: 10,),
                      
                        Container(
                          child: 
                          Text(
                            '0 km',
                            //'${ calculateDistance(profileState.user.location!, user.location!) }km away ',
                            style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                            ),
                        ),
                      
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
                                  Icon(LineIcons.glassCheers),
                                  SizedBox(width: 10,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Looking for', style: Theme.of(context).textTheme.bodySmall,),
                                      Text(user.lookingFor?.replaceAll('\n', '') ?? 'Someone to love', style: Theme.of(context).textTheme.bodyLarge,)
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
                            style: TextStyle(fontSize: 13, fontFamily: 'Proxima-Nova-Bold',fontWeight: FontWeight.w300,),
                           //style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                            ),
                        ),
                        SizedBox(height: 30,),
                      
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
                                color: index.isEven ? Color(0xFF12B2B2).withOpacity(0.25) : Color(0xFF9933FF).withOpacity(0.25),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              child: Text(user.interests[index], 
                              style: TextStyle(
                                fontWeight: FontWeight.w300, 
                                
                                )
                                ,),
                            ),
                          )
                        ),
                  
                  
                        SizedBox(height: 30,),
                      
                        Container(
                          child: Text(
                                "Instagram", 
                                style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold',  fontWeight: FontWeight.w400
                        ),
                                ),
                        ),
                        SizedBox(height: 400,),
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
                      context.read<SwipeBloc>().add(
                SwipeLeftEvent(
                  user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                  passedUser: user,
                  ));

                    },
                    child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                                  )
                                ]
                              ),
                          
                              child: Center(
                                child: SvgPicture.asset(
                                  item_icons[1]['icon'],
                                  width: item_icons[1]['icon_size'],
                                  
                                  ),
                              ),
                          
                            ),
                  ),
            SizedBox(width: 35,),

            InkWell(
              borderRadius: BorderRadius.circular(0),
              onTap: (){
                context.read<SwipeBloc>().add(
                SwipeRightEvent(
                  user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                 matchUser: user
                  ));

              },
              child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 10,
                  )
                ]
              ),
                    
              child: Center(
                child: SvgPicture.asset(
                  item_icons[3]['icon'],
                  width: item_icons[3]['icon_size'],
                  
                  ),
              ),
                    
                      ),
            ),
                ],
              ),
            
            ),
        ],
      ),
    );







    SingleChildScrollView(
      child: Container(
     //  height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       //padding: EdgeInsets.only(left: 20, right: 20),
       decoration: BoxDecoration(
        color: Colors.white,
       ),
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
            Stack(
              children: [
                
                
                // Container(
                //   //height: size.height *0.5,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                //    // image: DecorationImage(image: AssetImage('assets/images/girls/img_6.jpeg'), fit: BoxFit.cover),
                    
    
                //   ),
                //   child: SizedBox(
                //     height: 550,
                //     width: MediaQuery.of(context).size.width,
                //     child: ListView.builder(
                //       shrinkWrap: true,
                //       scrollDirection: Axis.horizontal,
                //       itemCount: user.imageUrls.length,
                //       //physics: BouncingScrollPhysics(),
                //       itemBuilder: (builder, index){
                //         return SizedBox(
                //           width: MediaQuery.of(context).size.width,
                //           child:  Image.network(user.imageUrls[index], fit: BoxFit.cover,)
                //         );
                //     }),
                //   )
                  
                // ),
                Positioned(
              left: size.width *0,
              top: size.height*0.06,
              child: Icon(Icons.arrow_back_ios_new_sharp,) ,
              ),
              ],
            ),
    
            SizedBox(height: 20,),
    
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        child: Text(
                          "${user.name},  ${user.age}", 
                          style: TextStyle(fontSize: 24, fontFamily: 'Proxima-Nova_Extrabold', color: Colors.black,fontWeight: FontWeight.bold),
                          ),
                      ),
                      SizedBox(width: 10,),
                      ClipOval(
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(color: Colors.green),
                        ),
                        
                      )
                    ],
                  ),
                
                  SizedBox(height: 10,),
                
                  Container(
                    child: Text(
                      'Flutter developer at my own startup ',
                      style: TextStyle(fontSize: 14, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                      ),
                  ),
                  SizedBox(height: 10,),
                
                  Container(
                    child: 
                    Text(
                      
                      '${ calculateDistance(profileState.user.location!, user.location!) }km away ',
                      style: TextStyle(fontSize: 11, fontFamily: 'ProximaNova-Regular', fontWeight: FontWeight.w300),
                      ),
                  ),
                
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
                            Icon(LineIcons.glassCheers),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Looking for', style: Theme.of(context).textTheme.bodySmall,),
                                Text(user.lookingFor ?? 'Someone to love', style: Theme.of(context).textTheme.bodyLarge,)
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
                          style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', color: Colors.black, fontWeight: FontWeight.w400
                  ),
                          ),
                  ),
                
                  SizedBox(height: 10,),
                
                  Container(
                    width: size.width * 0.85,
                    child: Text(
                      user.aboutMe ?? '-',
                      style: TextStyle(fontSize: 13, fontFamily: 'Proxima-Nova-Bold',fontWeight: FontWeight.w300,),
                     //style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                      ),
                  ),
                  SizedBox(height: 30,),
                
                  Container(
                    child: Text(
                          "Interstes", 
                          style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', color: Colors.black, fontWeight: FontWeight.w400
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
                          color: index.isEven ? Color(0xFF12B2B2).withOpacity(0.25) : Color(0xFF9933FF).withOpacity(0.25),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                        child: Text(user.interests[index], 
                        style: TextStyle(
                          fontWeight: FontWeight.w300, 
                          
                          color: Colors.black)
                          ,),
                      ),
                    )
                  ),
            
            
                  SizedBox(height: 30,),
                
                  Container(
                    child: Text(
                          "Instagram", 
                          style: TextStyle(fontSize: 20, fontFamily: 'Proxima-Nova-Bold', color: Colors.black, fontWeight: FontWeight.w400
                  ),
                          ),
                  ),
                  SizedBox(height: 40,),
                ],
              ),
            )
    
    
    
    
          ],
        ),
      ),
    );
    
  }
}