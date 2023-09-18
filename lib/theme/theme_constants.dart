import "package:flutter/material.dart";

ThemeData lightTheme =  ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  primarySwatch: Colors.green,
  appBarTheme: AppBarTheme(
    color: Colors.white
  )

  
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.teal,
  scaffoldBackgroundColor: Colors.grey[900]
  //Color.fromARGB(255, 22, 22, 22),


);

