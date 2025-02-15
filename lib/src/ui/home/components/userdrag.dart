import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Models/userpreference_model.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Blocs/SharedPrefes/sharedpreference_cubit.dart';
import '../../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../../Data/Models/tag_helper.dart';
import '../../../Data/Models/user.dart';
import '../../Profile/profile.dart';
import 'package:swipe_cards/swipe_cards.dart';


class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user, this.matchEngine});
  
  final User user;
  final MatchEngine? matchEngine;

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    var size= MediaQuery.of(context).size;
    int idx = 0;
    var myLocation = context.read<SharedpreferenceCubit>().state.myLocation;
    double? distanceD;
    int distance = 0;
    String km = context.read<UserpreferenceBloc>().state.userPreference?.showDistancesIn!??'km';
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
    return  Center(
      child: GestureDetector(
        onTapUp: (d){
        
          //if(pageController.hasClients){
            if(d.globalPosition.dx > MediaQuery.of(context).size.width /2){
              pageController.nextPage(duration: const Duration(microseconds: 1) , curve: Curves.linear);
         // pageController.animateToPage(idx + 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
            idx++;
             
            }else{
             // pageController.animateToPage(idx - 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
              pageController.previousPage(duration: const Duration(microseconds: 1), curve: Curves.linear);
              idx--; 
            }

         
        },
        child: Container(
                //height: size.height * 0.86,
                width: size.width * 0.98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: context.read<ThemeCubit>().state == ThemeMode.light? Colors.grey[350]: Colors.grey[800],
                  //border: Border.all(width: 2)
                ),
                
                child: Stack(
                  children: [
                    
                     ScrollConfiguration(
                      behavior:  MaterialScrollBehavior().copyWith(overscroll: false),
                       child: PageView.builder(
                          controller: pageController,
                          itemCount: user.imageUrls.length,
                          findChildIndexCallback: (key){
                            print(key);
                          },
                         
                        
                          physics: const  NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index) {
                                 return Container(         
                                      decoration:  BoxDecoration(
                                      image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        user.imageUrls[index],
                                      )
                                      ,
                                      fit: BoxFit.cover
                                      ),
                                     borderRadius: BorderRadius.circular(15) ), 
                                 
                                      // child: CachedNetworkImage(
                                      //   imageUrl: user.imageUrls[index],
                                      //   fit: BoxFit.cover,
                                      //   fadeInDuration: Duration.zero,
                                      //   fadeOutDuration: Duration.zero,
                                      //   ),
                                                              );
                          }
                           ),
                     ),

                     Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45.0),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black12,
                              Colors.black12,
                              Colors.transparent
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                           
                                
                          )
                          
                          )
                        ),
                      ),


                      
                    
                      
                   // ),
                   Align(
                    alignment: Alignment.topCenter,
                    child: LineIndicator(
                      user: user, 
                      pageController: pageController)
                    ),
            
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: size.height * 0.79/2.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0),
                              
                         
                          ],
                                
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          
                          )
                        ),
                      ),
                    ),
            
                    // Positioned(
                    //   bottom: 30,
                    //   left: 10,
                   //   child: 
                  //  Container(
                  //   child: ElevatedButton(
                  //     onPressed: (){
                  //       pageController.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.linear);
                  //     }, 
                  //     child: Text("Next"),
                  //     )
                  //  ),
      
      
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              
                              child: Row(
                                children: [
                                  Text('${user.name}  ${user.age}', 
                                  
                                  style: TextStyle(
                                    color: Colors.white, 
                                    fontSize: 24.sp,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.w300
                                    )
                                    ),
                                    SizedBox(width: 10,),

                                  (user.verified!=null && user.verified != VerifiedStatus.pending.name && user.verified != VerifiedStatus.notVerified.name) ? SizedBox(
                              child: 
                                    TagHelper.getTag(name: user.verified!, size: 20 ),

                                ):SizedBox(),
                              ]
                            )
                            ),
  
                            SizedBox(height: 10,),
                            myLocation !=null?Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                
                                  Icon(Icons.location_on_outlined, color: Colors.grey, size: 18,),
                                  const SizedBox(width: 4,),
                                   Container(
                                   child:  Text(
                                   // user.location != null ?'${distance} $km away ' : '',
                                    distance == 0? 'less than a $km away' :'$distance $km away',
                                    //"Recently Active", 
                                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[400],fontSize: 11.sp),
                                   //TextStyle(color: Colors.white, decoration: TextDecoration.none  ),
                                        
                                
                                    ),
                                 )
                                ],
                              ),
                            ):SizedBox(),

                            SizedBox(height:myLocation !=null? 10:null,),

                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                
                                  Icon(LineIcons.city, color: Colors.grey, size: 18,),
                                  const SizedBox(width: 4,),
                                 Container(
                                   child:  Text(
                                    user.city != ''? '${user.city},  ${user.country }' : user.country??'',
                                    //"Recently Active", 
                                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[400],fontSize: 11.sp),
                                   //TextStyle(color: Colors.white, decoration: TextDecoration.none  ),
                                        
                                
                                    ),
                                 ),
                                ],
                              ),
                            ),

                            SizedBox(height: 15,),
            
                            Container(
                              width: size.width*0.8,
                              child: Wrap(
                                
                                children:
                                               
                                List.generate( user.interests.length, (idx) => Container(
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                   decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[700]!,
                                      width: 0.5
                                    )
                                    
                                   ),
                                        
                                    child:   Padding(
                                      padding: const EdgeInsets.only(left: 12,right: 14, top: 5, bottom: 6),
                                      child: Text(
                                        user.interests[idx],
                                        style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey[400], fontSize: 11.sp)
                                        // TextStyle(
                                        //   color: Colors.white,
                                        //   //decoration: TextDecoration.none,
                                          
                                        //   ),
                                        
                                        ),
                                    ),
                                  )
                                  )
                              ),
                            ),
                            SizedBox(height:45,),
            
            
                          ],
                        ),
                      ),
                   // )
                   Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(
                                        value: context.read<ProfileBloc>(),
                                        child: BlocProvider.value(value: context.read<UserpreferenceBloc>(),
                                        child: BlocProvider.value(value: context.read<SharedpreferenceCubit>(),
                                        child: 
                                        Profile(user: user, profileFrom: ProfileFrom.swipe, matchEngine: matchEngine,ctrx: context,))))));
                          
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 80, right: 15),
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                           // borderRadius: BorderRadius.circular(45.0),
                            shape: BoxShape.circle,
                            color: Colors.grey
                            
                            ),
                            child: Icon(LineIcons.angleDoubleUp,size: 20, color: Colors.black,),
                          ),
                      ),
                      ),
            
                  ],
                  
            
                )
                
                // Card(
                //   // wi: size.width,
                //   // maxHeight: size.height * 0.75,
                //   // minWidth: size.width * 0.75,
                //   // minHeight: size.height * 0.6,
                //   child: 
                //   Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.withOpacity(0.3),
                //         blurRadius: 5,
                //         spreadRadius: 2
                //       ),
                //     ],
                //   ),
                //  ),
                // ),
            
              ),
      ),
    );
  }

  double calculateDistance(List<double> myLocation, List userLocation)  {
    var km = Geolocator.distanceBetween(myLocation[0], myLocation[1], userLocation[0], userLocation[1])/1000;
    return km;
    
    //return Geolocator.distanceBetween(7.3666915, 38.6714959, userLocation[0], userLocation[1])~/1000;
   } 
}

class LineIndicator extends StatefulWidget {
  const LineIndicator({
    super.key,
    required this.user,
    required this.pageController
  });

  final User user;
  final PageController pageController;

  @override
  State<LineIndicator> createState() => _LineIndicatorState();
}

class _LineIndicatorState extends State<LineIndicator> {
  int selectedIndex = 0;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        selectedIndex = widget.pageController.page!.toInt();
      });
    
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right:5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: List.generate(widget.user.imageUrls.length, 
            (index) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left:5.0),
                child: Divider(thickness: 1, color: selectedIndex == index? Colors.white : Colors.black26,),
              )
              ))
      ),
    );
  }
}