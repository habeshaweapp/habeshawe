import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/SwipeBloc/swipebloc_bloc.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/itsAmatch/itsAmatch.dart';

import '../../../Blocs/ContinueWith/continuewith_cubit.dart';
import '../../../Data/Models/model.dart';
import '../../../Data/Repository/Authentication/auth_repository.dart';
import '../../../dataApi/icons.dart';
import '../../Profile/profile.dart';

class UserCard extends StatelessWidget {
   UserCard({
    Key? key,
 
    
  }) : super(key: key);





  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    
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
                child: userDrag(size, state.users[0], context)
                ), 
              feedback: Material(child: userDrag(size, state.users[0], context)),
              childWhenDragging: userCount > 1 ?
               Material(child: userDrag(size, state.users[1], context))
               : Container(),
              onDragEnd: ((details) {
                if(details.velocity.pixelsPerSecond.dx < 0){
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
                userId: context.read<AuthBloc>().state.user!.uid,
                user: state.users[0]));
          }
          // if(index == 0){
          //   context.read<AuthRepository>().signOut();
          // }
          if(index == 3){
            context.read<SwipeBloc>().add(
              SwipeRightEvent(
               userId: context.read<AuthBloc>().state.user!.uid,
                
                user: state.users[0]));
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




  Widget userDrag(Size size, User user, BuildContext context) {
    return   Center(
      child: SizedBox(
              height: size.height * 0.79,
              width: size.width * 0.9,
              
              child: Stack(
                children: [
                  Container(         
                    decoration:  BoxDecoration(
                      image: DecorationImage(
                        image: 
                        CachedNetworkImageProvider(
                          user.imageUrls[0]
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
          
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
          
                      ],
          
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      
                      )
                    ),
                  ),
          
                  // Positioned(
                  //   bottom: 30,
                  //   left: 10,
                 //   child: 
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            
                            child: Text('${user.name}  ${user.age}', 
                            
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 24,
                              decoration: TextDecoration.none,
                              )
                              )
                              ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle
                                ),
                              ),
                              const SizedBox(width: 10,),
                             Container(
                               child: const Text("Recently Active", style: TextStyle(color: Colors.white, decoration: TextDecoration.none  ),
          
                            
                                ),
                             ),
                            ],
                          ),
                          SizedBox(height: 10,),
          
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children:
                 
                                List.generate(user.interests.length > 3? 3 : user.interests.length, (idx) => Container(
                                  margin: EdgeInsets.only(left: 10),
                                   decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2
                                    )
                                    
                                   ),
          
                                    child:   Padding(
                                      padding: const EdgeInsets.only(left: 8,right: 10, top: 3, bottom: 3),
                                      child: Text(
                                        user.interests[idx],
                                        style: TextStyle(
                                          color: Colors.white,
                                          decoration: TextDecoration.none
                                          ),
          
                                        ),
                                    ),
                                  )
                                  )
                              ),
    
                              
                                Container(
                                  height: 20,
                                  child: IconButton(
                                    onPressed:(){Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(user: user)));}, 
                                    icon: Icon(LineIcons.arrowDown, color: Colors.white,)
                                    )
                                  ),
                              
                            ],
                          )
          
          
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
    );
        }
       
      

          }
