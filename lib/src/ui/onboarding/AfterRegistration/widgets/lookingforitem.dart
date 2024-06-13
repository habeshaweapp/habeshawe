import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';

import '../../../../Blocs/ThemeCubit/theme_cubit.dart';

class LookingForItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;
  const LookingForItem ({super.key,required this.title, required this.icon, required this.isSelected,required this.onTap });



   static List<String> lookignForOpt = [
      'Long-term\n partner',
      'Christian,\n partner',
      'Teklil,\n marriage',
      'Nikah\n keep it halal',
      'Someone to chat\nNew friends',
      'Still figuring it\n out',
    ];

    static List<dynamic> icons =[
      Icon(FontAwesomeIcons.heartPulse, color: Colors.red,),
      Icon(FontAwesomeIcons.bookBible, color:Colors.black),
      Icon(FontAwesomeIcons.crown, color: Colors.amber,),
      Icon(Icons.diamond, color: Colors.pink,),
      Image.asset('assets/icons/goodbye.png', height: 27,width: 27,),
      Image.asset('assets/icons/rolling-eyes.png', height: 27,width: 27,)
      //Icon(FontAwesomeIcons.faceRollingEyes, color:Colors.black)

    ];
    
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
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
                            color: isSelected ? isDark? Colors.grey[900]: Colors.grey[300]: null,
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