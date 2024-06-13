import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Data/Models/message_model.dart';

import '../../Blocs/blocs.dart';
import '../../Data/Models/likes_model.dart';
import '../../Data/Models/user.dart';
import '../../dataApi/icons.dart';


class ItsAMatch extends StatelessWidget {
   final Like user;
   const ItsAMatch({ required this.user});

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: const Color.fromARGB(51, 182, 180, 180),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    String msg = '';
    return Scaffold(
      body: Stack(
          children: [
      
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                
                image: DecorationImage(image: CachedNetworkImageProvider(
                  user.user.imageUrls[0],
                  
              ), fit: BoxFit.cover
              ),
              
              ),
              
            ),
      
            Container(
              decoration: BoxDecoration(
                gradient:  LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0),
          
                      ],
          
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      
                      ),
                
              ),
      
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 2,),
                    SizedBox(
                      child: Text(
                        "IT\'S",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold,fontSize: 50, color: Colors.green),
                        ),
                    ),
                    SizedBox(
                      child: Text(
                        "A MATCH",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold,fontSize: 70, color: Colors.green),
                        ),
                    ),
                    Spacer(),
      
                    //IconButton(onPressed: (){}, icon: user.superLike!?Icon(Icons.star, color: Colors.blue,size: 35,): Icon( FontAwesomeIcons.heartPulse, color: Colors.red,)),
                    user.superLike!? IconButton(
                      onPressed: (){},
                      icon: Icon(Icons.star, color:Colors.blue,size:35),
                    ):
                    SvgPicture.asset(
                item_icons[3]['icon'],
                width: 35,
                
                ),
      
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${user.user.name} likes you too',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 10,),
                   // Spacer(),
      
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.79,
                      height: 40,
                      child: TextField(
                        onChanged: (value) { msg = value;},
                        style: TextStyle(color:Colors.white),
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.message),
                          filled: true,
                          fillColor: Colors.transparent
                          ,
                          hintText: 'Type here...',
                          //user.user.gender == 'men'? 'Limta wey koblye...': 'Temari nesh serategna...',
                          hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w200, fontSize: 13),
                          // border: OutlineInputBorder(
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: const BorderSide(
                          //     color:Colors.white,
                          //     width: 1,
                          //     style: BorderStyle.solid
                          //   )
                          // ),
                          enabledBorder: new UnderlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal)
                              ),

                          
                    
                          suffixIcon: Container(
                            margin: EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(80, 50),
                                shape: StadiumBorder(),
                                foregroundColor: Colors.grey[300],
                                backgroundColor: Colors.grey[800]
                                
                              ),
                              onPressed: (){
                                
                                if(msg.replaceAll(' ', '') == ''){

                                }else{
                                  BlocProvider.of<MatchBloc>(context).add(OpenChat(users: context.read<AuthBloc>().state.accountType!, message: Message(id: 'non', receiverId: user.user.id, senderId: context.read<AuthBloc>().state.user!.uid, message: msg,)));
                                  Navigator.pop(context);
                                }
                              }, 
                              child: Text('Send')
                              ),
                          )
                        ),
                      ),
                    ),
                    //Spacer(),
                    SizedBox(height: 55.h,),
      
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 40),
                              shape: StadiumBorder(),
                              backgroundColor: Colors.transparent
                              
                            ),
                            onPressed: (){
                               Navigator.pop(context);
                            }, 
                            child: Text(
                              'PLAY IT COOL',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey
                              ),
                            )
                            ),
                   // Spacer(),
                   SizedBox(height: 15,)
      
      
      
                    
                  ],
                ),
              ),
            ),
          ],
        )
          
    );
  }
}