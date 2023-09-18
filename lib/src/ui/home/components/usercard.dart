import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AdBloc/ad_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/SwipeBloc/swipebloc_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/itsAmatch/itsAmatch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../../Blocs/ContinueWith/continuewith_cubit.dart';
import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Data/Models/model.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../dataApi/icons.dart';
import '../../Profile/profile.dart';
import 'customtapgesturerecognizer.dart';

class UserCard extends StatelessWidget {
   UserCard({
    Key? key,
 
    
  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final pageController = PageController();
    
    return BlocConsumer<SwipeBloc, SwipeState>(
      listener: (context, state) {
        if(state is ItsaMatch){
          //GoRouter.of(context).pushNamed(MyAppRouteConstants.itsamatchRouteName);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ItsAMatch(user: state.user)));
        }
      },
      builder: ((context, state) {
    if(state is SwipeLoading){
      return Center(child: CircularProgressIndicator());
    }else if(state is SwipeLoaded){
      var userCount = state.users.length;
    return
       Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(bottom: 20,left: 20, right: 20,top: 5),
             child: Draggable(
              child: Material(
                child: userDrag(size, state.users[0], context, SwipableStackController())
                ), 
              feedback: Material(child: userDrag(size, state.users[0], context, SwipableStackController())),
              childWhenDragging: userCount > 1 ?
               Material(child: userDrag(size, state.users[1], context, SwipableStackController()))
               : Container(),
              onDragEnd: ((details) {
                if(details.velocity.pixelsPerSecond.dx < 0){
                  //details.velocity.
                 // context.read<SwipeBloc>().add(SwipeLeftEvent(user: state.users[0] ));
                  print('swiped left');
                }else{
                //  context.read<SwipeBloc>().add(SwipeRightEvent(users: state.users));
                //BlocProvider.of<SwipeBloc>(context).add(SwipeRightEvent(user: state.users[0]));
                  print('swiped right');
                }
              }),
              ),
           ),



            bottomButtons(context, state),


         ],
       );
    }if(state is SwipeError){
      return Center(child: Text('That is for today!'),);
    }
    
     else{ 
      return Text('something went wrong');
      }
    
      }
      )
    
    
    );

      
    
  }

  Container bottomButtons(BuildContext context, SwipeLoaded state) {
    return Container(
    //width: size.width,
    //height: 120,
    //decoration: BoxDecoration(color: Colors.brown),
    
    child: Padding(
  padding: const EdgeInsets.only(bottom: 2),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children:
    List.generate(item_icons.length, (index) {
      return InkWell(
        onTap: (){

          if(index == 1){
            context.read<SwipeBloc>().add(
              SwipeLeftEvent(
                  user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
                  passedUser: state.users[0],
                  ));
          }
          // if(index == 0){
          //   context.read<AuthRepository>().signOut();
          // }
          if(index == 3){
            context.read<SwipeBloc>().add(
              SwipeRightEvent(
               user: (context.read<ProfileBloc>().state as ProfileLoaded).user,
               matchUser: state.users[0]
                ));
          }
          

          if(index == 0){
            context.read<AuthRepository>().signOut();
          }
        },
        child: Container(
          width: item_icons[index]['size'],
          height: item_icons[index]['size'],
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
              item_icons[index]['icon'],
              width: item_icons[index]['icon_size'],
              
              ),
          ),
      
        ),
      );

    }),
  ),
    ),

  );
  }




  Widget userDrag(Size size, User user, BuildContext context, SwipableStackController? stackController){
    final pageController = PageController();
    int idx = 0;
    return (user.id != 'last') ? Center(
      child: GestureDetector(
        onTapUp: (d){
          //if(pageController.hasClients){
            if(d.globalPosition.dx > MediaQuery.of(context).size.width /2){
              pageController.nextPage(duration: Duration(milliseconds: 2), curve: Curves.linear);
         // pageController.animateToPage(idx + 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
              idx++;
            }else{
             // pageController.animateToPage(idx - 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
              pageController.previousPage(duration: Duration(milliseconds: 2), curve: Curves.linear);
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
                      behavior: MaterialScrollBehavior().copyWith(overscroll: false),
                       child: PageView.builder(
                          controller: pageController,
                          itemCount: user.imageUrls.length,
                         
                        
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index) =>
                          // InkWell(
                          //   onDoubleTap: (){
                          //     print('min taregiwalesh--------------------');
                          //   },
                          //   onTap: () {
                          //     print('-----------------------------------------------');
                          //     // if(details.globalPosition.dx < size.width * 0.9 /2 ){
                          //     //   pageController.animateToPage(index - 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
                          //     // }else{
                          //     //   pageController.animateToPage(index + 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
                          //     // }
                          //   },
                         // )
                          // RawGestureDetector(
                          //   gestures: <Type, GestureRecognizerFactory>{
                          //     CustomTapDownGestureRecognizer: GestureRecognizerFactoryWithHandlers(
                          //       () => CustomTapDownGestureRecognizer(
                          //         onTapDown: (TapDownDetails details){
                          //           print(details);
                          //           if(details.globalPosition.dx < size.width * 0.9 /2 ){
                          //           pageController.animateToPage(index - 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
                          //          }else{
                          //         pageController.animateToPage(index + 1, duration: Duration(milliseconds: 200), curve: Curves.linear);
                          //       }
                                         
                          //         }), 
                          //       (instance) { })
                          //   }
                            
                                         
                          
                               
                                  // onTapDown: (details){
                                  //   pageController.animateToPage( index + 2,duration: Duration(milliseconds: 200), curve: Curves.linear );
                               
                                  // },
                                    Container(         
                                      decoration:  BoxDecoration(
                                      image: DecorationImage(
                                      image: 
                                      CachedNetworkImageProvider(
                                        user.imageUrls[index],
                                        
                                      ),
                                      // NetworkImage(
                                      //   user.imageUrls == null ?
                                      //   null :
                                      //   user.imageUrls[0]
                                      //   ),
                                      //AssetImage(user.image),
                                      fit: BoxFit.cover
                                      ),
                                                 
                                      borderRadius: BorderRadius.circular(15)
                                                           )
                                                   
                                 
                               ),
                           ),
                     ),
                      
                   // ),
            
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
                              
                              child: Text('${user.name}  ${user.age}', 
                              
                              style: TextStyle(
                                color: Colors.white, 
                                fontSize: 24,
                                decoration: TextDecoration.none,
                                fontWeight: FontWeight.w300
                                )
                                )
                                ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  // Container(
                                  //   width: 8,
                                  //   height: 8,
                                  //   decoration: const BoxDecoration(
                                  //     color: Colors.green,
                                  //     shape: BoxShape.circle
                                  //   ),
                                  // ),
                                  Icon(Icons.location_on_outlined, color: Colors.green, size: 18,),
                                  const SizedBox(width: 4,),
                                 Container(
                                   child:  Text(
                                    user.location != null ?'${ calculateDistance(user.location!) }km away ' : '',
                                    //"Recently Active", 
                                   style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),
                                   //TextStyle(color: Colors.white, decoration: TextDecoration.none  ),
                                        
                                
                                    ),
                                 ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children:
                   
                                  List.generate(user.interests.length > 3? 3 : user.interests.length, (idx) => Container(
                                    margin: EdgeInsets.only(left: 10),
                                     decoration: BoxDecoration(
                                     // color: Colors.white.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 0.5
                                      )
                                      
                                     ),
            
                                      child:   Padding(
                                        padding: const EdgeInsets.only(left: 8,right: 10, top: 4, bottom: 5),
                                        child: Text(
                                          user.interests[idx],
                                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white)
                                          // TextStyle(
                                          //   color: Colors.white,
                                          //   //decoration: TextDecoration.none,
                                            
                                          //   ),
            
                                          ),
                                      ),
                                    )
                                    )
                                ),
          
                                
                                  Container(
                                    height: 20,
                                    child: IconButton(
                                      onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: user, stackController: stackController, imgindex: pageController.page ,)));}, 
                                      icon: Icon(LineIcons.arrowDown, color: Colors.white,)
                                      )
                                    ),
                                
                              ],
                            ),
                            SizedBox(height: 70,),
            
            
                          ],
                        ),
                      ),
                   // )
            
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
    ):
    Center(
      child: Container(
        color: Colors.white,
        // width: size.width*0.98,
        
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: Colors.grey[600],),
        // child: Center(
        //   child: BlocBuilder<AdBloc, AdState>(
        //     builder: (context, state){
        //       if(state is AdLoaded){
        //         return Column(
        //           children: List.generate(state.nativeAd!.length, (index) => 
                  
        //             Container(
        //               padding: EdgeInsets.only(bottom: 0),
        //       constraints: const  BoxConstraints(
        //             maxHeight: 400,
        //             minHeight: 320,
        //             maxWidth: 400,
        //             minWidth: 320
        //       ),
              
        //       child: AdWidget(ad: state.nativeAd![index] as AdWithView,),
        //     ),
            
            
        //         )
        //         );

        //       }else{
        //         return Container();
        //       }
        //     },
            
        //   ),
        // ),
      ),
    );
  }
  //final SharedPreferences prefes =  SharedPreferences.getInstance();

   int calculateDistance(List userLocation)  {

    
    
    return Geolocator.distanceBetween(7.3666915, 38.6714959, userLocation[0], userLocation[1])~/1000;
   }    
      


}


