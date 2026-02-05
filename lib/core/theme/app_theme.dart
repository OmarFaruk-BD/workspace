import 'package:flutter/material.dart';

abstract class AppColors {
  Color get primary;
  Color get primary2nd;
  Color get primary3rd;
  Color get primary4th;
  Color get primary5th;
  Color get primary6th;

  Color get secendary;
  Color get secendary2nd;
  Color get secendary3rd;
  Color get secendary4th;
  Color get secendary5th;
  Color get secendary6th;

  Color get surface50;
  Color get surface100;
  Color get surface200;
  Color get surface300;
  Color get surface400;
  Color get surface500;
  Color get surface600;
  Color get surface700;
  Color get surface800;
  Color get surface900;

  Color get success;
  Color get warning;
  Color get error;

  Color get background;
  Color get foreground;
}

abstract class AppTheme {
  ThemeData get theme;
  AppColors get colors;
  TextTheme get textTheme;
  InputDecorationTheme get inputDecorationTheme;
  FilledButtonThemeData get filledButtonThemeData;
  OutlinedButtonThemeData get outlinedButtonThemeData;
  ElevatedButtonThemeData get elevatedButtonThemeData;
}
