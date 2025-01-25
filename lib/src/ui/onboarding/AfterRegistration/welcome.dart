import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Repository/Authentication/auth_repository.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/namescreen.dart';
import 'package:lomi/src/ui/onboarding/onboardAllScreens.dart';

import '../../../Blocs/OnboardingBloc/onboarding_bloc.dart';
import '../../../Data/Models/user.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.end,
              children: [
               const LinearProgressIndicator(
                  value: 0.1,
            
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                    // Navigator.pop(context);
                      context.read<AuthRepository>().deleteAccount();
                    },
                    child: Icon(LineIcons.times,size: 35,)),
                ),
                SizedBox(height: 35.h,),
            
                Padding(
                  padding:  EdgeInsets.all(35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Center(
                          child: ClipRRect(
                           borderRadius: BorderRadius.circular(10),
                             child: Image.asset('assets/images/habeshawelogo.png',
                             width: 100.w,
                             height: 100.h,
                             )),
                        ),
                          const SizedBox(height: 40,),
                          Center(
                            child: Text("Welcome to HabeshaWe.",
                                style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 23.sp),
                          
                            ),
                          ),
                //           Center(
                  
                //   child: Text(
                //     'ሎሚ ብወረውር. ደረ ቷ ን መትቼ.. ል ቧ ን ባገኘሁት'
                //     ,style: Theme.of(context).textTheme.labelSmall,
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                          const SizedBox(height: 8,),
            
                          Center(
                            child: Text("Please follow these House Rules.",
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal,fontSize: 11.sp),
                          
                            ),
                          ),
                          SizedBox(height: 20,),
            
                          Row(
                            children: [
                              Icon(Icons.check, color:isDark?Colors.teal: Colors.green,), 
                              SizedBox(width: 10,),
                              Text('Be yourself.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 20),
                            child: Text(
                              'Make sure your photos, age, and bio are true to who you are.',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                            ),
                          ),
            
            
                          Row(
                            children: [
                              Icon(Icons.check, color: isDark?Colors.teal: Colors.green,), 
                              SizedBox(width: 10,),
                              Text('Stay safe.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),),
                            ],
                          ),
                          Padding(
                            padding:  EdgeInsets.only(top: 10.h,bottom: 20.h),
                            child: Text(
                              'Don\'t be too quick to give out personal information.',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                            ),
                          ),
            
            
                          Row(
                            children: [
                              Icon(Icons.check, color: isDark?Colors.teal: Colors.green,), 
                              SizedBox(width: 10,),
                              Text('Play it cool.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 20),
                            child: Text(
                              'Respect others and treat them as you would like to be treated.',
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                            ),
                          ),
            
            
                          Row(
                            children: [
                              Icon(Icons.check, color: isDark?Colors.teal: Colors.green,), 
                              SizedBox(width: 10,),
                              Text('Be proactive.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18.sp),),
                            ],
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 20),
                            child: Text(
                              'Always report bad behavior',
                                style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
                              ),
                          ),
            
                    ],
                  )
            
                  ),
                  
            
            
               // Spacer(),
               //SizedBox(height: MediaQuery.of(context).size.height*0.11,),
                SizedBox(height: 35.h),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        var email = context.read<AuthBloc>().state.user!.email;
                        var gmail = email ==''?context.read<AuthBloc>().state.user!.displayName:email;
                        User user = User(
                          id: context.read<AuthBloc>().state.user!.uid,
                          name: '', age: 0, gender: '', imageUrls:const [null,null,null,null,null,null], interests: [],
                          email: gmail,
                          provider: email == ''?'twitter':'google',
                          phoneNumber: context.read<AuthBloc>().state.user!.phoneNumber

                          );
                        
                        //if(Paint.enableDithering)
                        context.read<OnboardingBloc>().add(StartOnBoarding(user: user));
                       // GoRouter.of(context).pushNamed(MyAppRouteConstants.nameRouteName);
                       Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                                                                                                      child: const NameScreen() )));
                      }, 
                      child: Text('I Agree', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17.sp,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      ),
                      
                      ),
                  ),
                ),
               // Spacer(),
                //SizedBox(height: MediaQuery.of(context).size.height*0.11,),
            
            
            
              ],
            ),
          ),
        ) ),

    );
  }
}