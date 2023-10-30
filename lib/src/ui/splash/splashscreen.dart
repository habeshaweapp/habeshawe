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

import '../../Blocs/ThemeCubit/theme_cubit.dart';
import '../../Blocs/blocs.dart';
import '../UserProfile/userprofile.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..repeat(reverse: true);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
            //height: MediaQuery.of(context).size.height,
            child: FadeTransition(
              opacity: _animation,
              child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    SizedBox(width: 60,),
                    SizedBox(
                      height: size.height,
                      child: VerticalDivider(
                        color: Colors.red,
                        thickness: isDark ? 0.3 : 0.5,
                      ),
                    ),
                    SizedBox(
                      height: size.height,
                      child: VerticalDivider(
                        color: Colors.yellow,
                        thickness: isDark ? 0.5 : 1,
                      ),
                    ),
                    SizedBox(
                      height: size.height,
                      child: VerticalDivider(
                        color: Colors.green,
                        thickness: isDark ? 0.5 : 1,
                      ),
                    ),
      
                    
                  ]),
            )),
      ),
    );
  }
}
