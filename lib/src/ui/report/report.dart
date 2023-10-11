import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/interests.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: 
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(LineIcons.arrowLeft,size: 30,),
                    ),
        
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(LineIcons.times,size: 30,),
                    ),
                 ],
               ),
        
               SizedBox(height: 40,),
        
                Container(
                  width: 200,
                  //margin: EdgeInsets.all(35),
                  child: Text('Write your report',
                 // textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.green, ),
                  ),
                ),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  child: Text(
                    'The more detail you can give,\n the better we can understand\n what\'s happened.',
                    style: TextStyle(fontSize: 16,),
                    textAlign: TextAlign.center,
        
                    
                  ),
                ),
               // Spacer(flex: 1,),
               SizedBox(height: 30,),
                
        
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Tell us what happened...',
                        labelText: 'Feedback',
                        fillColor: Colors.green,
                        labelStyle: TextStyle(fontSize: 12)
                      ),
                      minLines: 1,
                      maxLines: 5,
                      onChanged: (value) {
                      },
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.8,
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      'If we need more information, we\'ll contact you at\nlos*****@gmail.com',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w300),
                      )
                  ),
                ),
        
        
        
               SizedBox(height: 30,),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.80,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: (){
                       // GoRouter.of(context).pushNamed(MyAppRouteConstants.interestsRouteName);
                       Navigator.push(context, MaterialPageRoute(builder: (context) => const Interests()));
                      }, 
                      child: Text('Submit', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      ),
                      
                      ),
                  ),
                ),
                const SizedBox(height: 20,)
               
        
              ],
            )
          ),
        )
        )
    );
        
   } 
   
    
}