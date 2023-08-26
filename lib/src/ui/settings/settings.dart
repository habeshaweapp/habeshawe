import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/ui/settings/components/body.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),),
        //backgroundColor: Colors.transparent,
        leading: BackButton(
          color: context.read<ThemeCubit>().state == ThemeMode.dark ?Colors.teal: Colors.green,
        ),
        actions: [
          Switch(
            value: context.read<ThemeCubit>().state == ThemeMode.dark , 
          onChanged: (value){
            context.read<ThemeCubit>().changeTheme();
          })
        ],
      ),

      body: Body(),
    );
  }
}