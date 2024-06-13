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
      'Christian\n partner',
      'Teklil\n marriage',
      'Nikah\n keep it halal',
      'Someone to chat\nNew friends',
      'Still figuring it\n out',
    ];

     List<Widget> icons =[
      Icon(FontAwesomeIcons.heartPulse, color: Colors.red,),
      Icon(FontAwesomeIcons.bookBible, color:Colors.black),
      Icon(FontAwesomeIcons.crown, color: Colors.amber,),
      Icon(Icons.diamond_outlined, color: Colors.pink,),
      Image.asset('assets/icons/goodbye.png', height: 27,width: 27,),
      Image.asset('assets/icons/rolling-eyes.png', height: 27,width: 27,)

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
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          
                          child: Icon(Icons.arrow_back,size: 35,)),
                      ),
                      
                      Container(
                        width: 200,
                        margin: EdgeInsets.only(left:35, top: 35),
                        child: Text('Right now\nI\'m looking \nfor',
                       // textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium,
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
                                Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                                                                                                      child: const SchoolName() )));
                              }
                            },
                            child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                            style: ElevatedButton.styleFrom(
                              shape: StadiumBorder(),
                              backgroundColor: selectedIndex == -1?Colors.grey:null,
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

