import 'package:flutter/material.dart';

class AppColors {
  static const MaterialColor blue = MaterialColor(
    _bluePrimaryValue,
    <int, Color>{
       50: Color(0xFFEDF5FF),
      100: Color(0xFFC7E1FF),
      200: Color(0xFFACD2FF),
      300: Color(0xFF86BEFF),
      400: Color(0xFF6EB1FF),
      500: Color(_bluePrimaryValue),
      600: Color(0xFF4390E8),
      700: Color(0xFF3570B5),
      800: Color(0xFF29578C),
      900: Color(0xFF1F426B),
    },
  );
  static const int _bluePrimaryValue = 0xFF4A9EFF;

  static const MaterialColor black = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
       50: Color(0xFFF2F3F5),
      100: Color(0xFFD9DBE1),
      200: Color(0xFFC4C9D2),
      300: Color(0xFFAEB1B9),
      400: Color(0xFF7D828B),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF36393F),
      700: Color(0xFF2F3136),
      800: Color(0xFF202225),
      900: Color(0xFF17181A),
    },
  );
  static const int _blackPrimaryValue = 0xFF5C6169;

  static const Color red = Color(0xFFED4245);
  static const Color green = Color(0xFF3BA55C);
}