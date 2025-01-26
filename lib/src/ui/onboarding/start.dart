import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/Blocs/ContinueWith/continuewith_cubit.dart';
import 'package:lomi/src/Data/Models/model.dart';
import 'package:lomi/src/Data/Repository/Database/database_repository.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Data/Models/userpreference_model.dart';
import '../../Data/Repository/SharedPrefes/sharedPrefes.dart';

class StartScreen extends StatefulWidget {
   StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> 
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
    var size = MediaQuery.of(context).size;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    var _controller = ValueNotifier<bool>(isDark);

    _controller.addListener(() {
      context.read<ThemeCubit>().changeTheme();
    },);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ? Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness: isDark? Brightness.light: Brightness.dark,
      ),
      
    );
    return Scaffold(
      body: Container(
          //height: size.height,
          //    decoration: const BoxDecoration(
          // image: DecorationImage(
          //   image: AssetImage('assets/images/habeshabg2.png'),
          //   alignment: Alignment.bottomRight,

          //   //fit: BoxFit.
          //   )
          //    ),

          child: Stack(
        children: [
          
          BlocBuilder<ContinuewithCubit, ContinuewithState>(
            builder: (context, state) {
              return state.status == ContinueStatus.submitting?
                FadeTransition(
                  opacity: _animation,
                  child: Stack(
                  children: [
                    Positioned(
                      left: 15.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.red,
                          thickness: isDark? 0.3: 0.5,
                          
                        ),
                      ),
                    ),
                     
                    Positioned(
                      left: 30.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.yellow,
                          thickness: isDark? 0.3: 1,
                          ),
                      ),
                    ),
                    Positioned(
                        left: 40.w,
                        child:
                    SizedBox(
                      height: size.height,
                    
                      child: VerticalDivider(
                        color: Colors.green,
                        thickness: isDark? 0.5: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                  )
              : SizedBox(
                child: Stack(
                  children: [
                    Positioned(
                      left: 15.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.red,
                          thickness: isDark? 0.2: 0.5,
                          
                        ),
                      ),
                    ),
                     
                    Positioned(
                      left: 30.w,
                      child: SizedBox(
                        height: size.height,
                        child: VerticalDivider(
                          color: Colors.yellow,
                          thickness: isDark? 0.3: 1,
                          ),
                      ),
                    ),
                    Positioned(
                        left: 40.w,
                        child:
                    SizedBox(
                      height: size.height,
                    
                      child: VerticalDivider(
                        color: Colors.green,
                        thickness: isDark? 0.5: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          ),


          Positioned(
            right: 10,
            top: 50,
            child: UnconstrainedBox(
      
        child: AdvancedSwitch(
          controller: _controller,
          enabled: true,
          height: 30,
          //width: 100,
          //
          //inactiveColor: Colors.amber,
          activeColor: Colors.grey[800]!,
          inactiveColor: Colors.grey[300]!,
          //inactiveChild: const Text('Dark'),
          //activeChild: const Text('Light'),
          thumb: ValueListenableBuilder<bool>(
            valueListenable: _controller, 
            builder: (_,value,__){
              return Transform.rotate(
                angle: -10,
                child: Icon(value?Icons.wb_sunny : Icons.brightness_2,size: 17, ));
            }),
        ),
      ),
            ),
          // Positioned(
          //   //alignment: Alignment.topLeft,
          //   left: 5,
          //   child: Image.asset(
          //     'assets/images/habeshabg2.png',
          //     height: 500,
          //     fit: BoxFit.cover,
          //     width: 127,
          //   ),
          // ),
          // Positioned(
          //   top: size.height/1.8,
          //   left: size.width*0.45,
          //   child: Center(
          //     child: BlocBuilder<ContinuewithCubit, ContinuewithState>(
          //       builder: (context, state) {
          //         if (state.status == ContinueStatus.submitting) {
          //           return CircularProgressIndicator(
          //             strokeWidth: 2,
          //           );
          //         }
          //         if(state.status == ContinueStatus.error) return SizedBox();
          //         return Container();
          //       },
          //     ),
          //   ),
          //  ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                //height: 140.h,
                height: size.height * 0.2,
              ),
              //const Spacer(flex: 1,),
               Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "HABESHAWE",
                  style: TextStyle(
                    fontSize: 35.sp,
                    // fontWeight: FontWeight.w300,
                    color: !isDark? Colors.grey[800]:Colors.grey[400],
                  ),
                ),
              ),

              // SizedBox(
              //   height: 300.h
              //   //size.height * 0.42,
              // ),
              //const Spacer(flex: 2,),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        //'By clicking Log In, you agree with our Terms. Learn how we process your data in our Privacy Policy and \nCookies Policy.',
                        'By continuing with an account, you agree to our Terms of Service and acknowledge that you have read our \nPrivacy Policy.',
                        style: TextStyle(
                          //color: Colors.white,
                          fontSize: 11.sp,
                          //fontWeight: FontWeight.w300,
                          color: Colors.grey
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
              
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   height: 50,
                    //   child: ElevatedButton.icon(
              
                    //     onPressed: (){},
                    //     icon: Icon(Icons.login,color: Colors.green,),
                    //     label: Text("Sign In with Google", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15),),
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(Colors.white),
                    //      // textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)),
                    //     ),
                    //     ),
                    // ),
                    // SizedBox(height: 20,),
              
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   height: 50,
                    //   child: ElevatedButton.icon(
              
                    //     onPressed: (){},
                    //     icon: Icon(Icons.login,color: Colors.green,),
                    //     label: Text("Sign In with Facebook", style: TextStyle(color: Colors.black,fontWeight: FontWeight.w300,fontSize: 15),),
                    //     style: ButtonStyle(
                    //       backgroundColor: MaterialStateProperty.all(Colors.white),
                    //      // textStyle: MaterialStateProperty.all(TextStyle(color: Colors.black)),
                    //     ),
                    //     ),
                    // ),
                    SizedBox(
                      height: 20.h
                      //size.height * 0.03,
                    ),
                    // Spacer(flex: 3,),
              
              
                    signInButton(
                      context: context,
                      text: "CONTINUE WITH GOOGLE",
                      icon: 'assets/icons/googleTransp2.png',
                      color: Colors.red,
                      isDark: isDark,
                      onPressed: () async {
                        // BlocProvider.of<AuthBloc>(context).add(LogInWithGoogle());
                        // final nextstate = await AuthBloc.s
              
                        //await context.read<AuthBloc>().add(LogInWithGoogle());
                        try{
                          
                        await context
                            .read<ContinuewithCubit>()
                            .continueWithGoogle();
                        }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('try again...'),backgroundColor: Colors.black38,));
                        }
              
                     
                     
                      },
                    ),
              
                    SizedBox(
                      height: 12.h,
                    ),
                    
              
                    signInButton(
                        context: context,
                        text: "CONTINUE WITH APPLE",
                        icon: 'assets/images/apple.png',
                        color: Colors.blue,
                        isDark: isDark,
                        
                        onPressed: () async {
                          try{
                          await context
                              .read<ContinuewithCubit>()
                              .continueWithTwitter();
                              }catch(e){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('try again...'),backgroundColor: Colors.black38,));
                        }
                        }
                        ),

                        
                
                 
                    SizedBox(
                      height: 20.h
                      //size.height * 0.03,
                    ),
                    //const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: ()async{
                          const url = 'https://linktr.ee/habeshawe';

                          if(await canLaunchUrl(Uri.parse(url))){
                            await launchUrl(Uri.parse(url));

                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('contact us on telegram! @habeshaweapp')));
                          }

                        },
                        child: Text(
                          'Trouble logging in?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11.sp,
                            //fontWeight: FontWeight.w300,
                      
                          ),
                        ),
                      ),
                    ),
                    //Spacer(),
                    SizedBox(
                      height: 35,
                    )
                  ],
                ),
              )
            ],
          ),
          
           
          
        ],
      )
      ),
    );
  }

  Container signInButton(
      {required BuildContext context,
      required String text,
      required String icon,
      required Color color,
      required bool isDark,
      double iconHeight = 17,
      double iconWidth = 17,
      required void Function() onPressed}) {
    //bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              isDark ? Colors.teal[900] : Colors.white),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: isDark&&iconHeight!=17?0: 5.0),
              child: Image.asset(
                icon,
                //color: color,
                height: iconHeight.sp,
                width: iconWidth.sp,
              ),
            ),
            Text(text,
                style: TextStyle(
                    color: isDark
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.4),
                    fontWeight: FontWeight.bold,
                   // fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontSize: 12.5.sp,
                    overflow: TextOverflow.ellipsis)),
            SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
