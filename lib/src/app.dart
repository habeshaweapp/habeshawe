import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ChatBloc/chat_bloc.dart';
import 'package:lomi/src/Blocs/ImagesBloc/images_bloc.dart';
import 'package:lomi/src/Blocs/OnboardingBloc/onboarding_bloc.dart';
import 'package:lomi/src/Blocs/ProfileBloc/profile_bloc.dart';
import 'package:lomi/src/Blocs/SwipeBloc/swipebloc_bloc.dart';
import 'package:lomi/src/Blocs/ContinueWith/continuewith_cubit.dart';
import 'package:lomi/src/Blocs/UserPreference/userpreference_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Data/Models/user_model.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/Data/Repository/Storage/storage_repository.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/dataApi/explore_json.dart';
import 'package:lomi/src/ui/Profile/profile.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/onboarding/phone.dart';
import 'package:lomi/src/ui/onboarding/start.dart';
import 'package:lomi/src/ui/onboarding/verificationscreen.dart';

import 'ui/UserProfile/userprofile.dart';
import 'ui/onboarding/AfterRegistration/addphotos.dart';
import 'ui/onboarding/AfterRegistration/birthday.dart';
import 'ui/onboarding/AfterRegistration/enablelocation.dart';
import 'ui/onboarding/AfterRegistration/genderscreen.dart';
import 'ui/onboarding/AfterRegistration/lookingfor.dart';
import 'ui/onboarding/AfterRegistration/namescreen.dart';
import 'ui/onboarding/AfterRegistration/schoolname.dart';
import 'ui/onboarding/AfterRegistration/showme.dart';
import 'ui/onboarding/AfterRegistration/interests.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var users = explore_json;
    users = users.map((user) => UserModel.fromJson(user)).toList();

    return MultiRepositoryProvider(
      providers: [
      RepositoryProvider(create: (context) => AuthRepository()),
      RepositoryProvider(create: (context) => DatabaseRepository()),
      RepositoryProvider(create: (context) => StorageRepository()),
    ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthBloc(authRepository: context.read<AuthRepository>())),
            BlocProvider(
                create: (context) =>
                    SwipeBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>(),
                    )..add(LoadUsers(userId: context.read<AuthBloc>().state.user!.uid ))),

            BlocProvider(
              create: (context) => OnboardingBloc(databaseRepository: context.read<DatabaseRepository>(), storageRepository: context.read<StorageRepository>()),          
            ),
            BlocProvider<ContinuewithCubit>(create: (context) => ContinuewithCubit(authRepository: context.read<AuthRepository>())),

            BlocProvider(create: (context) => ProfileBloc(authBloc: context.read<AuthBloc>(), databaseRepository: context.read<DatabaseRepository>(), storageRepository: context.read<StorageRepository>())..add(LoadProfile(userId: context.read<AuthBloc>().state.user!.uid))) ,

            BlocProvider(create: (context) => MatchBloc(databaseRepository: context.read<DatabaseRepository>(), authBloc: context.read<AuthBloc>())..add(LoadMatchs(userId: context.read<AuthBloc>().state.user!.uid)) ),
            BlocProvider(create: ((context) => ChatBloc(databaseRepository: context.read<DatabaseRepository>(), authBloc:  context.read<AuthBloc>()))),
            BlocProvider(create: (context) => UserpreferenceBloc(databaseRepository: context.read<DatabaseRepository>(), authBloc: context.read<AuthBloc>())..add(LoadUserPreference(userId: context.read<AuthBloc>().state.user!.uid))),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: Colors.green,
              // focusColor: Colors.green,
              // hintColor: Colors.green,
              primarySwatch: Colors.green,
            ),
            routeInformationParser: LomiAppRouter.router .routeInformationParser,
            routerDelegate: LomiAppRouter.router.routerDelegate,
            //home: AddPhotos(),
            //routerConfig: LomiAppRouter.returnRouter(),
          )),
    );
  }
}
