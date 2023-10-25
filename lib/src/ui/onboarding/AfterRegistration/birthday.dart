import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import 'package:lomi/src/app_route_config.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/lookingfor.dart';
import 'package:lomi/src/ui/onboarding/AfterRegistration/showme.dart';

class Birthday extends StatefulWidget {
  const Birthday({super.key});

  @override
  State<Birthday> createState() => _BirthdayState();
}

class _BirthdayState extends State<Birthday> {
  DateTime date = DateTime(2023,4,1);
  String day = '';
  String month = '';
  String year = '';

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
                value: 0.4,

              ),
             const Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(LineIcons.times,size: 35,),
              ),

              Container(
                width: 200,
                margin: EdgeInsets.symmetric(vertical: 35, horizontal: 50),
                child: Text('My \nbirthday is?',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: Colors.black),
                ),
              ),
              Spacer(flex: 2,),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 64,
                      width: MediaQuery.of(context).size.width*0.15,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'day',
                          labelStyle: TextStyle(fontSize: 12)
                        ),
                        //maxLength: 2,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          day =value;
                    
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 10,),

                    SizedBox(
                      height: 64,
                      width: MediaQuery.of(context).size.width*0.17,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'month',
                          labelStyle: TextStyle(fontSize: 12)
                        ),
                        //maxLength: 2,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          month=value;
                    
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(2),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.center,
                      ),
                    ),

                     SizedBox(width: 10,),


                    SizedBox(
                      height: 64,
                      width: MediaQuery.of(context).size.width*0.19,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'year',
                          labelStyle: TextStyle(fontSize: 12)
                        ),
                        //maxLength: 4,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          year=value;
                    
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        textInputAction: TextInputAction.next,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Center(
              //   //width: MediaQuery.of(context).size.width*0.7,
              //   child: TextButton(
              //     onPressed: () async{
              //      DateTime? newDate = await showDatePicker(context: context,
              //        initialDate: date, 
              //        firstDate: DateTime(1900), 
              //        lastDate: DateTime(2024)
              //        );
              //        //if cancle returns null so
              //        if(newDate == null) return;

              //        //if 'OK' => DateTime
              //        setState((){ date = newDate;});

              //     }, 
              //     child: Text('${date.day} / ${date.month} / ${date.year}',
              //               style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 23,letterSpacing: 5, fontWeight: FontWeight.w300),
              //               ),
                  
              //     ),
              // ),


              Center(
                child: Text('Your profile shows your age, not your \nbirth date.',
                    style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              



              Spacer(flex: 2,),
              BlocBuilder<OnboardingBloc, OnboardingState>(
                builder: (context, state) {
                  if(state is OnboardingLoaded){
                  return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: (){
                        final Today = DateTime.now();
                        if(day !=''&& month!=''&& year!=''){
                          final birthdate = DateTime(int.parse(year), int.parse(month), int.parse(day) );
                          final age = DateTime.now().difference(birthdate).inDays ~/365;
                          if(age<18 || age>80 ){
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('under age!')));
                          }else{
                          showDialog(
                            context: context, 
                            builder: (ctx)=> AlertDialog(
                              title: Text('Is your age ${age}?'),
                              actions: [
                                TextButton(
                                  onPressed: (){
                                     context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(age: age, birthday: birthdate.toString())));
                                     Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                                                                                                      child: const LookingFor() )));
                    
                                  }, 
                                  child: Text('Yes')
                                  ),
                               
                                TextButton(
                                  onPressed: (){
                                    Navigator.pop(context);

                                  }, child: Text('NO')
                                  ),

                              ],

                            ),
                          

                            );

                          }

                        }
                        //final birthdate = 

                      //   int age = Today.year - date.year;
                      //   int mth = Today.month - date.month;
                      //   if (mth < 0) age = age -1;
                      //   context.read<OnboardingBloc>().add(EditUser(user: state.user.copyWith(age: age, birthday: '${date.year}-${date.month}-${date.day}')));
                      //  // GoRouter.of(context).pushNamed(MyAppRouteConstants.showmeRouteName);
                      //   Navigator.push(context, MaterialPageRoute(builder: (ctx) => BlocProvider.value(value: context.read<OnboardingBloc>(),
                      //                                                                                 child: const LookingFor() )));
                      }, 
                      child: Text('CONTINUE', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 17,color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                      ),
                      
                      ),
                  ),
                );
                  }else{
                    return Center(child: CircularProgressIndicator(),);
                  }
                },
                
              ),
              const SizedBox(height: 20,)
             

            ],
          ),
        )
      )
    );

  }
}