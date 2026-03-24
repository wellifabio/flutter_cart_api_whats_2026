import 'package:flutter/material.dart';
import 'colors.dart';

abstract class AppTheme {
  static ThemeData apTheme = ThemeData.light().copyWith(
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(AppColors.c4),
        backgroundColor: WidgetStateColor.resolveWith((states) => AppColors.c1),
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: AppColors.c1),
      labelMedium: TextStyle(color: AppColors.c1),
      titleMedium: TextStyle(color: AppColors.c1),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.c2,
      contentTextStyle: TextStyle(color: AppColors.c3),
    ),
  );
}
