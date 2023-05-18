import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';

import '../../../Blocs/OnboardingBloc/onboarding_bloc.dart';

class SchoolName extends StatelessWidget {
  const SchoolName({super.key});

  @override
  Widget build(BuildContext context) {
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
             const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LineIcons.times,size: 35,),
              ),

              Container(
                width: 200,
                margin: EdgeInsets.all(35),
                child: Text('My \nschool is',
               // textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                ),
              ),
              Spacer(flex: 1,),
              

              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'School name'
                    ),
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
                    'This is how  it will appear in Lomi and you will not be able to change it',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
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
                      GoRouter.of(context).pushNamed(MyAppRouteConstants.interestsRouteName);
                    }, 
                    child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
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