import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/Profile/profile.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';
import 'package:lomi/src/ui/settings/settings.dart';

import '../../Blocs/blocs.dart';
import '../UserProfile/userprofile.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    WillPopScope(
      onWillPop: () async => false,
      child: BlocConsumer<AuthBloc, AuthState>(
        builder: (context, state) {
          if(state.status == AuthStatus.unauthenticated){

            Timer(Duration(seconds: 3),() => null); 
            return  StartScreen();
          }
          if(state.status == AuthStatus.authenticated){
            
            Timer(Duration(seconds: 3), () => null);
            return  Home();
          }else{
            return Text('something went wrong');
          }
        },
        listener: (context, state) {
          // if(state.status == AuthStatus.unauthenticated){
          //   Timer(Duration(seconds: 1), () => 
    
          //   GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.startRouteName)
    
          // ); 
    
          // }else if(state.status == AuthStatus.authenticated){
          //   Timer(Duration(seconds: 1), () => 
    
          //   GoRouter.of(context).pushReplacementNamed(MyAppRouteConstants.homeRouteName)
            
          // );
          // }

          

        
        child: Scaffold(
          body: Container(
            child: Center(
              child: Icon(LineIcons.lemonAlt, size: 63, color: Color.fromARGB(255, 8, 141, 13),),
            ),
          ),
        );
        },
      ),
    );
  }
}