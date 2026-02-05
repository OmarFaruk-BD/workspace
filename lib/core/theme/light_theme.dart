import 'package:flutter/material.dart';
import 'package:workspace/core/theme/app_theme.dart';
import 'package:workspace/core/theme/textstyles.dart';

class LightTheme extends AppTheme {
  @override
  AppColors get colors => LightColors();

  @override
  FilledButtonThemeData get filledButtonThemeData => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: EdgeInsets.all(10),
      textStyle: TextStyles.title,
      backgroundColor: colors.primary,
      foregroundColor: colors.foreground,
      disabledBackgroundColor: colors.surface400,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style:
            FilledButton.styleFrom(
              padding: EdgeInsets.all(10),
              textStyle: TextStyles.title,
              foregroundColor: colors.primary,
              backgroundColor: colors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ).copyWith(
              side: WidgetStateBorderSide.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(color: colors.surface400);
                }
                return BorderSide(color: colors.primary);
              }),
            ),
      );

  @override
  ElevatedButtonThemeData get elevatedButtonThemeData =>
      ElevatedButtonThemeData(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.all(10),
          textStyle: TextStyles.title,
          backgroundColor: colors.primary,
          foregroundColor: colors.foreground,
          disabledBackgroundColor: colors.surface400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: colors.background,
    prefixIconColor: colors.primary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.primary),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.primary),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: colors.primary),
    ),
  );

  @override
  TextTheme get textTheme =>
      TextTheme(titleLarge: TextStyles.title, titleMedium: TextStyles.subTitle);

  @override
  ThemeData get theme => ThemeData(
    useMaterial3: true,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      foregroundColor: colors.primary,
      backgroundColor: colors.background,
    ),
    filledButtonTheme: filledButtonThemeData,
    inputDecorationTheme: inputDecorationTheme,
    outlinedButtonTheme: outlinedButtonThemeData,
    elevatedButtonTheme: elevatedButtonThemeData,
  );
}

class LightColors extends AppColors {
  @override
  Color get primary => const Color(0xFF5DD3B6);

  @override
  Color get primary2nd => const Color(0xFF5DD3B6);

  @override
  Color get primary3rd => const Color(0xFF5DD3B6);

  @override
  Color get primary4th => const Color(0xFF5DD3B6);

  @override
  Color get primary5th => const Color(0xFF5DD3B6);

  @override
  Color get primary6th => const Color(0xFF5DD3B6);

  @override
  Color get secendary => const Color(0xFF008BFF);

  @override
  Color get secendary2nd => const Color(0xFF008BFF);

  @override
  Color get secendary3rd => const Color(0xFF008BFF);

  @override
  Color get secendary4th => const Color(0xFF008BFF);

  @override
  Color get secendary5th => const Color(0xFF008BFF);

  @override
  Color get secendary6th => const Color(0xFF008BFF);

  @override
  Color get surface100 => Colors.grey.shade100;

  @override
  Color get surface200 => Colors.grey.shade200;

  @override
  Color get surface300 => Colors.grey.shade300;

  @override
  Color get surface400 => Colors.grey.shade400;

  @override
  Color get surface50 => Colors.grey.shade50;

  @override
  Color get surface500 => Colors.grey.shade500;

  @override
  Color get surface600 => Colors.grey.shade600;

  @override
  Color get surface700 => Colors.grey.shade700;

  @override
  Color get surface800 => Colors.grey.shade800;

  @override
  Color get surface900 => Colors.grey.shade900;

  @override
  Color get success => const Color(0xFF12BF52);

  @override
  Color get error => const Color(0xFFF40000);

  @override
  Color get warning => const Color(0xFFFACC15);

  @override
  Color get background => Colors.white;

  @override
  Color get foreground => Colors.white;
}
