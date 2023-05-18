import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lomi/src/Data/Models/model.dart';

import 'components/body.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen(this.userMatch);
  final UserMatch userMatch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(userMatch.matchedUser.imageUrls[0]),
          
              ),
             
              Text(userMatch.matchedUser.name,style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
        ),
       // leading: Icon(Icons.arrow_back_ios_new, color: Colors.black,),
      ),
      body: Body(userMatch),
    );
    
  }
}