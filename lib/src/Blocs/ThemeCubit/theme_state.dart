part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  
  ThemeState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

// class ThemeInitial extends ThemeState {}

// class LightTheme extends ThemeState{
//   final ThemeMode themeMode;
  
//   LightTheme({required this.themeMode});

//   @override
//   // TODO: implement props
//   List<Object> get props => [themeMode];
// }

// class DarkTheme extends ThemeState{
//   final ThemeMode themeMode;

//   DarkTheme({required this.themeMode});

//   @override
//   // TODO: implement props
//   List<Object> get props => [themeMode];
// }
