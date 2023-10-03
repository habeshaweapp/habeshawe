import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/blocs.dart';
import '../../Blocs/ThemeCubit/theme_cubit.dart';
import 'components/body.dart';

class EditProfile extends StatelessWidget {
  // final ProfileBloc profileBloc;
  // final BuildContext ctx;
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark? Color.fromARGB(255, 22, 22, 22):null,
        title: Text('Edit Profile', style: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),),
        //backgroundColor: Colors.white,
        leading: BackButton(
          color: isDark? Colors.teal: Colors.green,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ? Color.fromARGB(51, 182, 180, 180) : Colors.white,
        systemNavigationBarIconBrightness: !isDark? Brightness.dark: Brightness.light,
      ),
      ),

      body: Body(),
    );
  }
}