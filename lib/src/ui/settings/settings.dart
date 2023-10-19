import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lomi/src/Blocs/ThemeCubit/theme_cubit.dart';
import 'package:lomi/src/ui/settings/components/body.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';


class Settings extends StatelessWidget {
  const Settings({super.key});
  

  @override
  Widget build(BuildContext context) {
    bool isDark = context.read<ThemeCubit>().state == ThemeMode.dark;
    final _controller = ValueNotifier<bool>(!isDark);
    
    _controller.addListener(() {
      context.read<ThemeCubit>().changeTheme();
    },);
    return Scaffold(
      
      appBar: AppBar(
       systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: isDark ? Colors.grey[900] : Colors.white,
        systemNavigationBarIconBrightness: isDark? Brightness.light: Brightness.dark,
      ),
        title: Text('Settings', style: TextStyle( fontWeight: FontWeight.w400, fontSize: 17),),
        //backgroundColor: Colors.transparent,
        leading: BackButton(
          color: context.read<ThemeCubit>().state == ThemeMode.dark ?Colors.teal: Colors.green,
        ),
        backgroundColor: isDark? Color.fromARGB(255, 22, 22, 22):null,
        actions: [
          // Switch(
          //   value: context.read<ThemeCubit>().state == ThemeMode.dark , 
          // onChanged: (value){
          //   context.read<ThemeCubit>().changeTheme();
          // }),

          UnconstrainedBox(
        
            child: AdvancedSwitch(
              controller: _controller,
              enabled: true,
              height: 30,
              width: 120,
              //
              //inactiveColor: Colors.amber,
              activeColor: Colors.grey,
              inactiveColor: Colors.grey[800]!,
              inactiveChild: const Text('Dark'),
              activeChild: const Text('Light'),
              thumb: ValueListenableBuilder<bool>(
                valueListenable: _controller, 
                builder: (_,value,__){
                  return Icon(value? Icons.lightbulb: Icons.lightbulb_outline);
                }),
            ),
          ),
          const SizedBox(width: 5,)

        ],

        
      ),

      body:  Body(),
    );
  }
}