import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/verificationscreen.dart';

import '../../Blocs/PhoneAuthBloc/phone_auth_bloc.dart';

class Phone extends StatelessWidget {
  const Phone({super.key});

  @override
  Widget build(BuildContext context) {
    String phoneNumber ='';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
       // leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: (){},),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My number is",
              style: Theme.of(context).textTheme.headlineMedium
             // !.copyWith(fontWeight: FontWeight.bold)
              ,
              //textAlign: TextAlign.start,
              ),
              SizedBox(height: 40,),
              Form(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                    // height: 100,
                      child: DropdownButtonFormField(
                        items: [
                          DropdownMenuItem(child: Text('ET +251'), value: '+251',),
                        ], 
                       // style: Theme.of(context).textTheme.headlineSmall,
                        onChanged: (value){
                          phoneNumber = value.toString();
                        },
                        value: '+251',
                        isExpanded: true,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        //underline: Container(height: 2, color: Colors.grey,),
                        ),
                    ),
                    SizedBox(width: 20,),
              
                    Expanded(
                      child: TextFormField(
                        onChanged: (value){
                          phoneNumber = value.toString();
                        },
                       // style:  Theme.of(context).textTheme.headlineSmall,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          )
                        ),
                        
                        
                      ),
                    )
              
                    
                  ],
              
                ),
              ),
      
              SizedBox(height: 25,),
      
              Text(
                'When you tap Continue. Lomi will send a text with verification code. Message and data rates may apply. The verified phone number can be used to log in. Learn what happens when your number changes.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 25,),
      
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width*0.90,
                  height: 50,
                  child: ElevatedButton(
                  onPressed: (){
                    context.read<PhoneAuthBloc>().add(SendOtpToPhone(phoneNumber: phoneNumber));
                    GoRouter.of(context).pushNamed(MyAppRouteConstants.welcomeRouteName);
                  //  Navigator.push(context, MaterialPageRoute(builder: ()=> Verification();))
                  }, 
                  child: Text(
                    'CONTINUE',
                    //style: Theme.of(context).textTheme.labelLarge,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400
                    ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.green,
                      ),
                      
                  ),
                  
                ),
              )
          
              // Container(
              //   height: 200,
              //   decoration: BoxDecoration(color: Colors.red),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}