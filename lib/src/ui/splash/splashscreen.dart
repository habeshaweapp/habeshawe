import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import '../../Blocs/ThemeCubit/theme_cubit.dart';

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

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ?  Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness: !isDark? Brightness.dark: Brightness.light,
      ),
    );

    return Scaffold(
      
      body: SafeArea(
        child: Container(
            //height: MediaQuery.of(context).size.height,
            child: FadeTransition(
              opacity: _animation,
              child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    //SizedBox(width: 20,),
                    Positioned(
                      left: 15.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.red,
                          thickness: isDark ? 0.2 : 0.5,
                        ),
                      ),
                    ),
                    //SizedBox(width: 5,),
                    Positioned(
                      left: 30.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.yellow,
                          thickness: isDark ? 0.3 : 1,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.green,
                          thickness: isDark ? 0.4 : 1,
                        ),
                      ),
                    ),

                    BlocListener<AuthBloc,AuthState>(
                  listener: (context,state){
                    if(state.firstTime == true && state.isCompleted == true){
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);

                    }

                  },
                  child: Container(),
                ),
      
                    
                  ]),
            )),
      ),
    );
  }
}
