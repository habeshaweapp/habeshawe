import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                value: 0.1,

              ),
             const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LineIcons.times,size: 35,),
              ),

              Padding(
                padding:  EdgeInsets.all(35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      const Center(
                        child:  Icon(LineIcons.lemonAlt, size: 63, color: Color.fromARGB(255, 8, 141, 13),)),
                        const SizedBox(height: 10,),
                        Center(
                          child: Text("Welcome to Lomi.",
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.normal),
                        
                          ),
                        ),
                        Center(
                
                child: Text(
                  'ሎሚ ብወረውር. ደረ ቷ ን መትቼ.. ል ቧ ን ባገኘሁት'
                  ,style: Theme.of(context).textTheme.labelSmall,
                  textAlign: TextAlign.center,
                ),
              ),
                        const SizedBox(height: 8,),

                        Center(
                          child: Text("Please follow these House Rules.",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
                        
                          ),
                        ),
                        SizedBox(height: 20,),

                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.green,), 
                            SizedBox(width: 10,),
                            Text('Be yourself.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 20),
                          child: Text(
                            'Make sure your photos, age, and bio are true to who you are.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),


                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.green,), 
                            SizedBox(width: 10,),
                            Text('Stay safe.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 20),
                          child: Text(
                            'Don\'t be too quick to give out personal information.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),


                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.green,), 
                            SizedBox(width: 10,),
                            Text('Play it cool.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 20),
                          child: Text(
                            'Respect others and treat them as you would like to be treated.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),


                        Row(
                          children: [
                            Icon(Icons.check, color: Colors.green,), 
                            SizedBox(width: 10,),
                            Text('Be proactive.', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),),
                          ],
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 20),
                          child: Text(
                            'Always report bad behavior',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ),

                  ],
                )

                ),
                


              Spacer(),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.70,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (){
                      GoRouter.of(context).pushNamed(MyAppRouteConstants.nameRouteName);
                    }, 
                    child: Text('I Agree', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                    ),
                    
                    ),
                ),
              ),
              Spacer(),
              



            ],
          ),
        ) ),

    );
  }
}