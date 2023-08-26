import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Blocs/ThemeCubit/theme_cubit.dart';
import 'components/body.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),),
        //backgroundColor: Colors.white,
        leading: BackButton(
          color: isDark? Colors.teal: Colors.green,
        ),
      ),

      body: Body(),
    );
  }
}