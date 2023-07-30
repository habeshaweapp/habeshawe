import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/ui/verifyProfile/components/body.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Data/Models/model.dart';

class BeforeyouContinue extends StatelessWidget {
  final User user;
  const BeforeyouContinue({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return Container(
      height: MediaQuery.of(context).size.height*0.46,
      width: MediaQuery.of(context).size.width*0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height:20,),
          Text('Before you continue', 
          //style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height:40,),
          Container(
            padding: EdgeInsets.only(left: 20),
            child:
          Row(
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 17,),
              Text(' Prep your lighting', style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(style: Theme.of(context).textTheme.bodySmall,
              '''- Choose a well-lit environment 
- Turn up your brightness
- Avoid harsh glare and
  backlighting
              '''
            ),
          ),


          SizedBox(height:10,),


  Container(
    padding: EdgeInsets.only(left: 20),
    child:
          Row(
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 17,),
              Text(' Show your face',style: Theme.of(context).textTheme.bodyLarge,),
            ],
          )),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(style: Theme.of(context).textTheme.bodySmall,
              '''- face the camera directly 
- Remove hats, sunglasses, and
  face covering
              '''
            ),
          ),
         // SizedBox(height: MediaQuery.of(context).size.height*0.1,),
         Spacer(),

          ElevatedButton(
                            onPressed: () async{
                              ImagePicker _picker = ImagePicker();
                              final _image = await _picker.pickImage(source: ImageSource.camera);

                              if(_image == null){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image not selected')));
                              }

                              if(_image != null){
                                context.read<ProfileBloc>().add(VerifyMe(user: user, image: _image, type: 'queen'));
                              }
                              
                              
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.green,
                                shape: StadiumBorder()
                                ),
                            child: Container(
                              width: width * 0.4,
                              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                              child: Text('Verify Me', textAlign: TextAlign.center),
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