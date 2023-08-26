import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  void changeTheme(){
    emit(state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
    // if(isDark){
    //   emit(ThemeMode.dark);
    // }else{
    //   emit(ThemeMode.light);
    // }
  }
  
  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    return ThemeMode.values[json['themeMode'] as int];
     //json['themeMode'] == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
  
  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    // TODO: implement toJson
    return {'themeMode': state.index};
  }
}
