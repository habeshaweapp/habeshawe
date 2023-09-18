import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/schoolname.dart';

import 'widgets/lookingforitem.dart';

class LookingFor extends StatefulWidget {
  const LookingFor({super.key});

  @override
  State<LookingFor> createState() => _LookingForState();
}

class _LookingForState extends State<LookingFor> {
 int selectedIndex = -1;
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

    List<Icon> icons =[
      Icon(FontAwesomeIcons.heart, color: Colors.red,),
      Icon(FontAwesomeIcons.faceGrinHearts, color:Colors.amber),
      Icon(FontAwesomeIcons.champagneGlasses, color: Colors.amber,),
      Icon(FontAwesomeIcons.comment, color: Colors.blue,),
      Icon(FontAwesomeIcons.hand, color: Colors.amber),
      Icon(FontAwesomeIcons.faceRollingEyes, color:Colors.teal)

    ];
    
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, state) {
            if(state is OnboardingLoading){
              return Center(child: CircularProgressIndicator(),);
            }
            if( state is OnboardingLoaded){
              return SingleChildScrollView(
                child: Column(
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
                      SizedBox(height: size.height/5 ,),
                      
                      Container(
                        height: size.width *0.63,
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 5,
                          children: List.generate(6, 
                          (index) => LookingForItem(
                            title: lookignForOpt[index], 
                            icon: icons[index], 
                            isSelected: selectedIndex == index, 
                            onTap: (){
                              setState(() {
                                selectedIndex = index;
                              });
                              
                      
                            }
                            )
                          ),
                      
                        ),
                      ),
                      
              
              
              
              
                      
                      
                      SizedBox(height: size.height*0.060,),
                      //Spacer(flex: 1,),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width*0.70,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (){
                              if(selectedIndex != -1 ){ 
                                context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(lookingFor: selectedIndex )));
                                //GoRouter.of(context).pushNamed(MyAppRouteConstants.schoolRouteName);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const SchoolName()));
                              }
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
                ),
                          ],
                        ),
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

