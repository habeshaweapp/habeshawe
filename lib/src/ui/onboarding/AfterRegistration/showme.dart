import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';

import '../../../Blocs/OnboardingBloc/onboarding_bloc.dart';

class ShowMe extends StatefulWidget {
  const ShowMe({super.key});

  @override
  State<ShowMe> createState() => _ShowMeState();
}

class _ShowMeState extends State<ShowMe> {
 // List<bool> _selections = [false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          if(state is OnboardingLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is OnboardingLoaded){
          return SafeArea(
            child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LinearProgressIndicator(
                  value: 0.5,
      
                ),
               const Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(LineIcons.times,size: 35,),
                ),
      
                Container(
                  width: 200,
                  margin: EdgeInsets.all(35),
                  child: Text('Show Me',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                  ),
                ),
                Spacer(flex: 1,),
                
      
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: ToggleButtons(
                      
                      children: [
                       const Text("MEN"),
                       const Text("WOMEN")
                      ], 
                      isSelected: state.user.gender =='Men' ? [false,true] : [true,false],
                      direction: Axis.vertical,
                      borderRadius: BorderRadius.all(Radius.circular(30),),
                      selectedBorderColor: Colors.green,
                      selectedColor: Colors.black,
                      fillColor: Colors.white,
                      borderWidth: 5,
                      
                      onPressed: (index){ },
                      
                      ),
                  ),
                ),
      
      
      
                Spacer(flex: 2,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        GoRouter.of(context).pushNamed(MyAppRouteConstants.lookingforRouteName);
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
          )
        ,
      );
      }else{
        return Center(child: Text('somthing went Wrong...'),);
      }
}
      
    )
    );

  }
}