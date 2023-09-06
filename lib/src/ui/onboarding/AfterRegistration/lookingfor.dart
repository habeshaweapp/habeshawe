import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';

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
                                context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(lookingFor: lookignForOpt[selectedIndex].replaceAll('\n', '') )));
                                GoRouter.of(context).pushNamed(MyAppRouteConstants.schoolRouteName);
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

class LookingForItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final bool isSelected;
  final VoidCallback onTap;
  const LookingForItem ({super.key,required this.title, required this.icon, required this.isSelected,required this.onTap });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return InkWell(
              onTap: onTap,
              // (){
              //  // context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(lookingFor: lookignForOpt[index])));
              //                // selectedIndex = index;
              //        },
              child: Container(
                       width: size.width*0.32,
                        height: size.height*0.18,
                                             // margin: EdgeInsets.all(10),
                        child: Card(                    
                            shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                            elevation: 2,
                            color: isSelected ? Colors.grey[400]: Colors.grey[200],
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Icon(Icons.heart_broken, color: Colors.red,),
                              icon,
                              SizedBox(height: 10,),
                              Text(title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: size.width * 0.03),
                              
                              )
                            ],
                                                ),
                                              ),
                                            ),
                          );
  }
}