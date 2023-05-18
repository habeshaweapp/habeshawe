import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Data/Models/message_model.dart';

import '../../Blocs/blocs.dart';
import '../../Data/Models/user.dart';


class ItsAMatch extends StatelessWidget {
   User user;
   ItsAMatch({ required this.user});

  @override
  Widget build(BuildContext context) {
    String msg = '';
    return Scaffold(
      body: Stack(
          children: [
      
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                
                image: DecorationImage(image: NetworkImage(
                  user.imageUrls[0],
                  
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
                        "IT\'S\nA MATCH",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                    ),
                    Spacer(),
      
                    IconButton(onPressed: (){}, icon: Icon(Icons.heart_broken, color: Colors.green,)),
      
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${user.name} likes you too',
                        style: TextStyle(color: Colors.green),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    //SizedBox(height: 50,),
                   // Spacer(),
      
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.79,
                      height: 50,
                      child: TextField(
                        onChanged: (value) { msg = value;},
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.message),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'temari nesh serategna',
                          hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w200),
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
                                BlocProvider.of<MatchBloc>(context).add(OpenChat(message: Message(id: 'non', senderId: user.id, receiverId: context.read<AuthBloc>().state.user!.uid, message: msg, timestamp: DateTime.now())));
                              }, 
                              child: Text('Send')
                              ),
                          )
                        ),
                      ),
                    ),
                    //Spacer(),
                    SizedBox(height: 70,),
      
                    ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              shape: StadiumBorder(),
                              backgroundColor: Colors.transparent
                              
                            ),
                            onPressed: (){
                               Navigator.pop(context);
                            }, 
                            child: Text('KEEP SWIPING')
                            ),
                    Spacer(),
      
      
      
                    
                  ],
                ),
              ),
            ),
          ],
        )
          
    );
  }
}