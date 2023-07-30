import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  void changeTheme(bool isDark){
    if(isDark){
      emit(ThemeState(themeMode: ThemeMode.dark));
    }else{
      emit(ThemeState(themeMode: ThemeMode.light));
    }
  }
}
