import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Data/Models/message_model.dart';

import '../../Blocs/blocs.dart';
import '../../Data/Models/likes_model.dart';
import '../../Data/Models/user.dart';


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
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                    ),
                    SizedBox(
                      child: Text(
                        "A MATCH",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold,fontSize: 50, color: Colors.green),
                        ),
                    ),
                    Spacer(),
      
                    IconButton(onPressed: (){}, icon: user.superLike!?Icon(Icons.star, color: Colors.blue,size: 35,): Icon( FontAwesomeIcons.heartPulse, color: Colors.red,)),
      
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${user.user.name} likes you too',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    //SizedBox(height: 50,),
                   // Spacer(),
      
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.79,
                      height: 40,
                      child: TextField(
                        onChanged: (value) { msg = value;},
                        decoration: InputDecoration(
                          //prefixIcon: Icon(Icons.message),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'temari nesh serategna',
                          hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w200, fontSize: 11),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color:Colors.white,
                              width: 1,
                              style: BorderStyle.solid
                            )
                          ),
                    
                          suffixIcon: Container(
                            margin: EdgeInsets.all(8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(100, 50),
                                shape: StadiumBorder(),
                                foregroundColor: Colors.white
                                
                              ),
                              onPressed: (){
                                BlocProvider.of<MatchBloc>(context).add(OpenChat(users: context.read<AuthBloc>().state.accountType!, message: Message(id: 'non', receiverId: user.user.id, senderId: context.read<AuthBloc>().state.user!.uid, message: msg,)));
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
                              minimumSize: Size(200, 50),
                              shape: StadiumBorder(),
                              backgroundColor: Colors.transparent
                              
                            ),
                            onPressed: (){
                               Navigator.pop(context);
                            }, 
                            child: Text('PLAY IT COOL')
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