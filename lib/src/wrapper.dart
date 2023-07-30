import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';
import 'package:lomi/src/ui/onboarding/start.dart';
import 'package:lomi/src/ui/splash/splashscreen.dart';

import 'Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
class Wrapper extends StatelessWidget{
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state){
        if(state.status == AuthStatus.unknown){
          return const SplashScreen();
        }
        if(state.status == AuthStatus.unauthenticated){
          return const StartScreen();
        }
        if(state.status == AuthStatus.authenticated){
          //context.read<AuthRepository>().signOut();
          if(state.newAccount!){
            return WelcomeScreen();
          }
          return const Home();
        }else{
          return Container();
        }
      }
    );

}
}