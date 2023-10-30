import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lomi/src/Blocs/AuthenticationBloc/bloc/auth_bloc.dart';
import 'package:lomi/src/ui/verifyProfile/components/body.dart';

import '../../../Blocs/ProfileBloc/profile_bloc.dart';
import '../../../Data/Models/model.dart';

class BeforeyouContinue extends StatelessWidget {
  final User user;
  final bool? onlyVerifyMe;
  final BuildContext profileContext;
  const BeforeyouContinue({super.key, required this.user, required this.profileContext, this.onlyVerifyMe = false});

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
          SizedBox(height:20.h,),
          Text('Before you continue', 
          //style: Theme.of(context).textTheme.bodyLarge,
          style: TextStyle(fontSize: 14.sp)
          ),
          
          SizedBox(height:40.h,),
          Container(
            padding: EdgeInsets.only(left: 20),
            child:
          Row(
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 17,),
              Text(' Prep your lighting', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp),),
            ],
          ),),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
              '''- Choose a well-lit environment 
- Turn up your brightness
- Avoid harsh glare and
  backlighting
              '''
            ),
          ),


          SizedBox(height:10.h,),


  Container(
    padding: EdgeInsets.only(left: 20),
    child:
          Row(
            children: [
              Icon(Icons.verified, color: Colors.blue, size: 17,),
              Text(' Show your face',style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 14.sp),),
            ],
          )),
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp),
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
                              var _image = await _picker.pickImage(source: ImageSource.camera);
                              try {
                                final lastIndex = _image!.path.lastIndexOf(new RegExp(r'.jp'));
                                final splitted = _image.path.substring(0, (lastIndex));
                                final outPath = "${splitted}_out${_image.path.substring(lastIndex)}";
                                 _image = await FlutterImageCompress.compressAndGetFile(_image.path, outPath, quality: 50
                                );
                                
                              } catch (e) {
                                
                              }

                              if(_image == null){
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Image not taken')));
                              }

                              if(_image != null){
                                profileContext.read<ProfileBloc>().add(VerifyMe(user: user, image: _image, onlyVerifyMe: onlyVerifyMe));
                                Navigator.pop(context);
                              }
                              
                              
                            },
                            style: ElevatedButton.styleFrom(
                                // backgroundColor: Colors.green,
                                shape: StadiumBorder()
                                ),
                            child: Container(
                              width: width * 0.4,
                              //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                              child: Text('Verify Me', textAlign: TextAlign.center, style: TextStyle(fontSize: 13.sp) ),
                            )
                            )
                            ,

                        //SizedBox(height: 5,),
                  ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                             
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