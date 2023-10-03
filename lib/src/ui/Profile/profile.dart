import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lomi/src/ui/Profile/components/body.dart';
import 'package:swipable_stack/swipable_stack.dart';

import '../../Data/Models/model.dart';

class Profile extends StatelessWidget {
  final User user;
  SwipableStackController? stackController;

   Profile({Key? key, required this.user, this.stackController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      //appBar: PreferredSize(child: SliverAppBar(), preferredSize: 550)
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
        
      // ),
      // extendBodyBehindAppBar: false,

      body: Body(user: user, stackController: stackController),
    );
    
  }
}