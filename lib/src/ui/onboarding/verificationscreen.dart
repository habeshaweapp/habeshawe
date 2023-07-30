import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Blocs/PhoneAuthBloc/phone_auth_bloc.dart';
import '../../app_route_config.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  String otpInput = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios_new_sharp, color: Colors.black,)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My code is',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),

            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('251911623030'),
                SizedBox(width: 10,),
                
                Container(
                  //width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: InkWell(
                    
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'RESEND',
                    style: Theme.of(context).textTheme.bodyLarge,
                    ),
                ),
                ),
                )
              ],
            ),
            SizedBox(height: 25,),

            Form(
              child: Row(
                children: List.generate(6, (index) => 
                     Padding(
                       padding: const EdgeInsets.only(right:5.0),
                       child: SizedBox(
                                         height: 64,
                                         width: MediaQuery.of(context).size.width *0.13,
                                         child: TextFormField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                         // border: UnderlineInputBorder()
                         
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        textInputAction: TextInputAction.next,
                        onChanged: (value){
                          otpInput += value;  
                        },
                        
                                         ) ,
                                       ),
                     )
                )
              )
              ),

              SizedBox(height: 45,),
              BlocConsumer<PhoneAuthBloc, PhoneAuthState>(
                listener: (context, state) {
                  if(state is PhoneAuthVerified){
                    GoRouter.of(context).pushNamed(MyAppRouteConstants.welcomeRouteName);
                  }

                  if(state is PhoneAuthError){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error))
                    );
                  }
                },
                builder: (context, state) {
                 // if(state is Phone)
                 if(state is PhoneAuthLoading){
                  return Center(child: CircularProgressIndicator(),);
                 }

                 if(state is PhoneAuthLoading){
                 
                  return Center(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width*0.90,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){
                                    //context.read<PhoneAuthBloc>().add(VerifySentOtp(otpCode: otpInput.toString(), verificationId: state.verificationId));

                                    GoRouter.of(context).pushNamed(MyAppRouteConstants.welcomeRouteName);
              
                                  }, 
                                  child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                                  style: ElevatedButton.styleFrom(
                                    shape: StadiumBorder(),
                                  ),
                                  
                                  ),
                              ),
                            );

                 }
                 
                 else{
                  return Text('getting your code...');
                 }
                },
              )
          ],
        ),

      ),
    );
  }
}