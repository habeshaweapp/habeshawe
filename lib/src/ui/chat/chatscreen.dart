import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Data/Models/model.dart';

import 'components/body.dart';
import 'components/bottomsendmessage.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.userMatch);
  final UserMatch userMatch;


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
       // backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        //toolbarHeight: 100,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: (){
              context.pop();
            }, 
            icon: Icon(Icons.arrow_back, color: !isDark ? Colors.black.withOpacity(0.7) : Colors.white),
            ),
          ),
        title: Row(
          
          children: [
            CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userMatch.imageUrls[0]),                       
              ),
           
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userMatch.name,style: Theme.of(context).textTheme.bodyMedium,),
                  userMatch.id != 'ds come and fix later'?
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          shape:  BoxShape.circle,
                          color: Colors.green,
                          border: Border.all(
                            width: 2,
                            color: Colors.white,
                          )
            
                        ),
                      ),
                      SizedBox(width: 3,),
                      Text('Active now', style: TextStyle(color: Colors.grey, fontSize: 12),)
                    ],
                  ): Text('last seen recently', style: TextStyle(fontSize: 12, color: Colors.grey)),
            
            
                ],),
            )
          ],
        ),
       // leading: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
       actions: [
        IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.more_vert, color: isDark? Colors.white : Colors.black ))
       ],
      ),
      body: Body(userMatch),

      //bottomNavigationBar: BottomSendMessage(userMatch) ,
    );
    
  }
}