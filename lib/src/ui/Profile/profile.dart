import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/likes_model.dart';
import 'package:lomi/src/ui/Profile/components/body.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../Data/Models/enums.dart';
import '../../Data/Models/model.dart';

class Profile extends StatelessWidget {
  final User user;
  final ProfileFrom profileFrom;
  final Like? likedMeUser;
  final MatchEngine? matchEngine;
  final BuildContext ctrx;
  

   Profile({Key? key, required this.user,required this.profileFrom, this.likedMeUser, this.matchEngine,required this.ctrx }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      //appBar: PreferredSize(child: SliverAppBar(), preferredSize: 550)
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
        
      // ),
      // extendBodyBehindAppBar: false,

      body: profileFrom == ProfileFrom.profile?
       BlocBuilder<ProfileBloc, ProfileState>(
         builder: (context, state) {
           return Body(user: (state as ProfileLoaded).user, profileFrom: profileFrom, likedMeUser: likedMeUser, matchEngine: matchEngine, ctrx: ctrx);
         },
       ):
       Body(user: user, profileFrom: profileFrom, likedMeUser: likedMeUser, matchEngine: matchEngine, ctrx: ctrx),
    );
    
  }
}