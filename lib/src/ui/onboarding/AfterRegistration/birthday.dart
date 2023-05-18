import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';

class Birthday extends StatefulWidget {
  const Birthday({super.key});

  @override
  State<Birthday> createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  DateTime date = DateTime(2023,4,1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const LinearProgressIndicator(
                value: 0.4,

              ),
             const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LineIcons.times,size: 35,),
              ),

              Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                child: Text('My \nbirthday is?',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                ),
              ),
              Spacer(flex: 2,),
              
              Center(
                //width: MediaQuery.of(context).size.width*0.7,
                child: TextButton(
                  onPressed: () async{
                   DateTime? newDate = await showDatePicker(context: context,
                     initialDate: date, 
                     firstDate: DateTime(1900), 
                     lastDate: DateTime(2024)
                     );
                     //if cancle returns null so
                     if(newDate == null) return;

                     //if 'OK' => DateTime
                     setState((){ date = newDate;});

                  }, 
                  child: Text('${date.day} / ${date.month} / ${date.year}',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 23,letterSpacing: 5, fontWeight: FontWeight.w300),
                            ),
                  
                  ),
              ),
              Center(
                child: Text('Your profile shows your age, not your \nbirth date.',
                    style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              



              Spacer(flex: 2,),
              BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if(state is OnboardingLoaded){
                  return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        final Today = DateTime.now();

                        int age = Today.year - date.year;
                        int mth = Today.month - date.month;
                        if (mth < 0) age = age -1;
                        context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(age: age, birthday: '${date.year}-${date.month}-${date.day}')));
                        GoRouter.of(context).pushNamed(MyAppRouteConstants.showmeRouteName);
                      }, 
                      child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      ),
                      
                      ),
                  ),
                );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
                
              ),
              const SizedBox(height: 20,)
             

            ],
          ),
        )
      )
    );

  }
}