import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../Blocs/ThemeCubit/theme_cubit.dart';

class LookingForItem extends StatelessWidget {
  final String title;
  final Icon icon;
  final bool isSelected;
  final VoidCallback onTap;
  const LookingForItem ({super.key,required this.title, required this.icon, required this.isSelected,required this.onTap });



   static List<String> lookignForOpt = [
      'Long-term\n partner',
      'Long-term,\n open to short',
      'Short-term,\n open to long',
      'Short-term fun',
      'New friends',
      'Still figuring it\n out',
    ];

    static List<Icon> icons =[
      Icon(FontAwesomeIcons.heart, color: Colors.red,),
      Icon(FontAwesomeIcons.faceGrinHearts, color:Colors.amber),
      Icon(FontAwesomeIcons.champagneGlasses, color: Colors.amber,),
      Icon(FontAwesomeIcons.comment, color: Colors.blue,),
      Icon(FontAwesomeIcons.hand, color: Colors.amber),
      Icon(FontAwesomeIcons.faceRollingEyes, color:Colors.teal)

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
                            color: isSelected ? isDark? Colors.grey[900]: Colors.grey[400]: null,
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