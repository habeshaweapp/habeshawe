import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/interests.dart';

import '../../../Blocs/OnboardingBloc/onboarding_bloc.dart';

class SchoolName extends StatelessWidget {
  const SchoolName({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if(state is OnboardingLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            
            if(state is OnboardingLoaded){
              return
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(
                value: 0.7

              ),
             Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          
                          child: Icon(Icons.arrow_back,size: 35,)),
                      ),

              Container(
                width: 200,
                margin: EdgeInsets.all(35),
                child: Text('My \nschool is',
               // textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              
              Spacer(flex: 1,),
              

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: TextField(
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'University/school name'
                    ),
                    inputFormatters: [
                              LengthLimitingTextInputFormatter(55),
                            
                            ],
                    onChanged: (value) {
                      context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(school: value)));
                    },
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    'This is how  it will appear in HabeshaWe and you will not be able to change it',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300,fontSize: 11.sp),
                    )
                ),
              ),



              Spacer(flex: 2,),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                     // GoRouter.of(context).pushNamed(MyAppRouteConstants.interestsRouteName);
                     if(state.user.school !=null && state.user.school!.length >1 ){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                                                                                                      child: const Interests() )));
                    }else{
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('please input a valid school!', style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp, color: Colors.white)) ,backgroundColor: Colors.black38, ));


                    }
                    }, 
                    child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17.sp,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: isDark?Colors.teal:Colors.green
                    ),
                    
                    ),
                ),
              ),
              const SizedBox(height: 20,)
             

            ],
          ),
        );
            }
            else{
              return Text('something went wrong');
            }
   } 
   )
        )
    );
  }
}
