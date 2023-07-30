import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';

class LookingFor extends StatelessWidget {
  const LookingFor({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> lookignForOpt = [
      'Long-term\n partner',
      'Long-term,\n open to short',
      'Short-term,\n open to long',
      'Short-term fun',
      'New friends',
      'Stil figuring it\n out',
    ];
    //int selectedIndex = 0;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if(state is OnboardingLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if( state is OnboardingLoaded){
              return Column(
                children: [
                const LinearProgressIndicator(
                  value: 0.6       
                ),
              Container(
               // width: MediaQuery.of(context).size.width,
               // height: MediaQuery.of(context).size.height,
                margin: EdgeInsets.symmetric(horizontal:8),
        
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                   const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(LineIcons.times,size: 35,),
                    ),
        
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(left:35, top: 35),
                      child: Text('Right now\nI\'m looking \nfor',
                     // textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35, top:10),
                      child: Text(
                        'Increase compatibility by sharing yours!',
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                            ),
                    ),
                    //Spacer(flex: 1,),
                    SizedBox(height: 110,),
        
                    
        
                    Row(
                      children: List.generate(3, (index) => 
                          InkWell(
                            onTap: (){
                              context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(lookingFor: lookignForOpt[index])));
                             // selectedIndex = index;
                            },
                            child: Container(
                                              width: size.width*0.32,
                                              height: size.height*0.18,
                                             // margin: EdgeInsets.all(10),
                                              child: Card(
                                                
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                elevation: 2,
                                                color: Colors.grey[200],
                                                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.heart_broken, color: Colors.red,),
                              SizedBox(height: 10,),
                              Text(lookignForOpt[index],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                                                ),
                                              ),
                                            ),
                          ),
                      )
                    ,),
                    //SizedBox(height: 5,),
        
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(3, (index) => 
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            onTap: (){
                              
                              //selectedIndex = index + 3;
                              context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(lookingFor: lookignForOpt[index+3])));
                              
        
                            },
                            child: Container(
                                              width: size.width*0.32,
                                              height: size.height*0.18,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10))
                                              ),
                                              //margin: EdgeInsets.all(10),
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                elevation: 2,
                                                color: Colors.grey[100],
                                                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(LineIcons.capsules, color: Colors.purple,),
                             //s SizedBox(height: 10,),
                              Text(
                                lookignForOpt[3+index],
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                              )
                            ],
                                                ),
                                              ),
                                            ),
                          ),
                    )
                  ,),
        
        
                    
        
                    
        
        
                    SizedBox(height: 100,),
                    //Spacer(flex: 1,),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width*0.70,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: (){
                            //context.read<OnboardingBloc>().add(event)
                            GoRouter.of(context).pushNamed(MyAppRouteConstants.schoolRouteName);
                          }, 
                          child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                          ),
                          
                          ),
                      ),
                    ),
                   // const SizedBox(height: 20,)
                   
        
                  ],
                ),
              ),
            ],
          );
        }else{
          return Center(child: Text('something went wrong...'),);
        }

          }

        )
  
  
      
      )
    );
  }
}