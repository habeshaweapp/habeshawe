import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/Data/Models/enums.dart';

class PageViewItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final Color color;
  final void Function() ontap;
  const PageViewItem({super.key, required this.color, required this.icon, required this.title, required this.description, required this.buttonText, required this.ontap});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return  Column(
                    //mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
    
                      //Image.asset(image, height: 70,),
                      Icon(icon, size: 70.h, color:color,),
                      SizedBox(height: 30.h,),
                      Text(title,
                      
                      style: Theme.of(context).textTheme.bodyMedium ,
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 45.w),
                        child: Text(description
                         ,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12.sp) ,
                          textAlign: TextAlign.center,
                          ),
                      ),
                        SizedBox(height: 15.h,),

                        ElevatedButton(
                          
                          onPressed: ontap, 
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 45.w,vertical: 10.h),
                            child: Text(buttonText,style: TextStyle(color:isDark ? Colors.grey: Colors.black),),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor: isDark? Colors.grey[900]: Colors.white,
                          )
                          
                          )
                    ],
                  );
  }


}