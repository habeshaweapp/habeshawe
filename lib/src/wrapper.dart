import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/AdBloc/ad_bloc.dart';
import 'package:lomi/src/Blocs/UpdateWallBloc/update_wall_bloc.dart';
import 'package:lomi/src/Data/Models/enums.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/Data/Repository/Database/ad_repository.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/ui/home/home.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';
import 'package:lomi/src/ui/onboarding/start.dart';
import 'package:lomi/src/ui/splash/splashscreen.dart';

import 'Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'Blocs/SharedPrefes/sharedpreference_cubit.dart';
import 'Blocs/ThemeCubit/theme_cubit.dart';
import 'Blocs/blocs.dart';
import 'Data/Repository/Payment/payment_repository.dart';
import 'Data/Repository/Storage/storage_repository.dart';
import 'updatewall.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateWallBloc, UpdateWallState>(
      builder: (context, state) {
        if (state is ShutDownThisApp) {
          return const UpdateWall();
        }
        return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          if (state.status == AuthStatus.unknown) {
            return const SplashScreen();
          }
          if (state.status == AuthStatus.unauthenticated) {
            return BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, state) {
              return StartScreen();
            });
          }
          if (state.status == AuthStatus.authenticated) {
            //context.read<AuthRepository>().signOut();
            if (state.accountType == Gender.nonExist || !state.isCompleted!) {
              return BlocProvider(
                lazy: false,
                create: (context) => OnboardingBloc(
                    databaseRepository: context.read<DatabaseRepository>(),
                    storageRepository: context.read<StorageRepository>(),
                    authBloc: context.read<AuthBloc>()),
                child: const WelcomeScreen(),
              );
            }

            return MultiBlocProvider(providers: [
              BlocProvider(
                  lazy: false,
                  create: (context) => PaymentBloc(
                      paymentRepository: PaymentRepository(),
                      authBloc: context.read<AuthBloc>(),
                      databaseRepository: context.read<DatabaseRepository>())),
              BlocProvider(
                  lazy: false,
                  create: (context) => AdBloc(adRepository: AdRepository())),
              BlocProvider(
                  lazy: false,
                  create: (contet) => SharedpreferenceCubit()..getMyLocation()),
              BlocProvider(
                  lazy: false,
                  create: (context) => SwipeBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>(),
                      adBloc: context.read<AdBloc>(),
                      paymentBloc: context.read<PaymentBloc>())),
              BlocProvider(
                  lazy: false,
                  create: (context) => LikeBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>(),
                      paymentBloc: context.read<PaymentBloc>()
                      )
                    ..add(LoadLikes(
                        userId: state.user!.uid, users: state.accountType!))),
              BlocProvider(
                  lazy: false,
                  create: (context) => MatchBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>())
                    ..add(LoadMatchs(
                        userId: state.user!.uid, users: state.accountType!))),
              BlocProvider(
                  lazy: false,
                  create: (context) => ProfileBloc(
                      authBloc: context.read<AuthBloc>(),
                      databaseRepository: context.read<DatabaseRepository>(),
                      storageRepository: context.read<StorageRepository>())),
              BlocProvider(
                  lazy: false,
                  create: ((context) => ChatBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>(),
                      storageRepository: context.read<StorageRepository>()))),
              BlocProvider(
                  lazy: false,
                  create: (context) => UserpreferenceBloc(
                      databaseRepository: context.read<DatabaseRepository>(),
                      authBloc: context.read<AuthBloc>())
                    ..add(LoadUserPreference(
                        userId: state.user!.uid, users: state.accountType!))),
            ], child: const Home());
          } else {
            return Container();
          }
        });
      },
    );
  }
}
