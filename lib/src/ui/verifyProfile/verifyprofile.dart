import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/ui/verifyProfile/components/body.dart';

import '../../Data/Models/user.dart';
import 'components/beforeyoucont.dart';

class VerifyProfile extends StatelessWidget {
  final User user;
  const VerifyProfile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height*0.46,
      width: MediaQuery.of(context).size.width*0.7,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 50,),
              
              Text('/', style: TextStyle(fontSize: 40),),

              Icon(LineIcons.crown, size: 50, color: Colors.amber,),
              
            ],
          ),
          SizedBox(height:35,),
          Text('Get Verified', style: TextStyle(fontSize: 20),),
          SizedBox(height:40,),
          Text('Prove you\'re the person in your\nprofile by taking a photo. if you \nmatch, boom, you\'re verified!',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.black.withOpacity(0.6)),
                //style: TextStyle(fontSize: 15 ),
                textAlign: TextAlign.center,
                ),
         // SizedBox(height: MediaQuery.of(context).size.height*0.1,),
         Spacer(),

          ElevatedButton(
                            onPressed: () {
                              context.pop();
                              //context.read<DatabaseRepository>().getUsersBasedonPreference(state.user.id);
                              showDialog(
                              context: context, 
                              builder: ((context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),

                                  content: BeforeyouContinue(user: user),
                                );
                                
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.green,
                                shape: StadiumBorder()
                                ),
                            child: Container(
                              width: width * 0.4,
                              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                              child: Text('Continue', textAlign: TextAlign.center),
                            )
                            )
                            ,

                        //SizedBox(height: 5,),
                  ElevatedButton(
                            onPressed: () {
                              context.pop();
                              //context.read<DatabaseRepository>().getUsersBasedonPreference(state.user.id);
                            },
                            style: ElevatedButton.styleFrom(
                                 backgroundColor: Colors.white,
                                shape: StadiumBorder()),
                            child: Container(
                              width: width * 0.4,
                             // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                              child: Text('Maybe Later', textAlign: TextAlign.center, style: TextStyle(color: Colors.black.withOpacity(0.5))),
                            )
                            ),
                      Spacer(),

        ],
      ),
    );
  }
}