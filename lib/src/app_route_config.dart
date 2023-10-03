import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/itsAmatch/itsAmatch.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';
import 'package:lomi/src/ui/settings/settings.dart';
import 'package:lomi/src/wrapper.dart';

import 'ui/splash/splashscreen.dart';


class LomiAppRouter{
  
   static final GoRouter router = GoRouter(
      routes: [
        GoRoute(
          name: MyAppRouteConstants.wrapperRouteName,
          path: '/',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Wrapper());
          },
          ),
          GoRoute(
          name: MyAppRouteConstants.splashRouteName,
          path: '/splash',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SplashScreen());
          },
          ),

          GoRoute(
          name: MyAppRouteConstants.homeRouteName,
          path: '/home',
          pageBuilder: (context, state) {
            print(BlocProvider.of<AuthBloc>(context).state.status);
            return (BlocProvider.of<AuthBloc>(context).state.status == AuthStatus.authenticated)?
            const MaterialPage(child: Home()):
            MaterialPage(child: StartScreen());
          },

          ),

        GoRoute(
          name: MyAppRouteConstants.startRouteName,
          path: '/start',
          pageBuilder: (context, state) {
            return  MaterialPage(child: StartScreen());
          },
          ),

        GoRoute(
          name: MyAppRouteConstants.phoneRouteName,
          path: '/phone',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Phone());
          },
          ),

        GoRoute(
          name: MyAppRouteConstants.verificationRouteName,
          path: '/verification',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Verification());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.welcomeRouteName,
          path: '/welcome',
          pageBuilder: (context, state) {
            return const MaterialPage(child: WelcomeScreen());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.nameRouteName,
          path: '/name',
          pageBuilder: (context, state) {
            return const MaterialPage(child: NameScreen());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.genderRouteName,
          path: '/gender',
          pageBuilder: (context, state) {
            return const MaterialPage(child: GenderScreen());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.birthdayRouteName,
          path: '/birthday',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Birthday());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.showmeRouteName,
          path: '/showme',
          pageBuilder: (context, state) {
            return const MaterialPage(child: ShowMe());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.lookingforRouteName,
          path: '/lookingfor',
          pageBuilder: (context, state) {
            return const MaterialPage(child: LookingFor());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.schoolRouteName,
          path: '/school',
          pageBuilder: (context, state) {
            return const MaterialPage(child: SchoolName());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.interestsRouteName,
          path: '/interests',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Interests());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.addphotosRouteName,
          path: '/addphotos',
          pageBuilder: (context, state) {
            return const MaterialPage(child: AddPhotos());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.enablelocationRouteName,
          path: '/enablelocation',
          pageBuilder: (context, state) {
            return const MaterialPage(child: EnableLocation());
          },
        ),

        GoRoute(
          name: MyAppRouteConstants.itsamatchRouteName,
          path: '/itsamatch',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Home());
          },
          ),

        GoRoute(
          name: MyAppRouteConstants.settingsRouteName,
          path: '/settings',
          pageBuilder: (context, state) {
            return const MaterialPage(child: Settings());
          },
          ),


      ],
      errorBuilder: (context, state) {
       
        return Text("error");
      },

      redirect: (context, state) {
        
      },

     // refreshListenable: BlocL

      );

     
}

class MyAppRouteConstants {
  static const String splashRouteName = 'splash';
  static const String wrapperRouteName = 'wrapper';
  static const String homeRouteName = 'home';
  static const String startRouteName = 'start';
  static const String phoneRouteName = 'phone';
  static const String verificationRouteName = 'verification';
  static const String welcomeRouteName = 'welcome';
  static const String nameRouteName = 'name';
  static const String genderRouteName = 'gender';
  static const String birthdayRouteName = 'birthday';
  static const String showmeRouteName = 'showme';
  static const String lookingforRouteName = 'lookingfor';
  static const String schoolRouteName = 'school';
  static const String interestsRouteName = 'interests';
  static const String addphotosRouteName = 'addphotos';
  static const String enablelocationRouteName = 'enablelocation';
  static const String itsamatchRouteName = 'itsamatch';
  static const String settingsRouteName = 'settings';

}