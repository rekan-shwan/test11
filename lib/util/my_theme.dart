import 'package:flutter/material.dart';

//0xFFC4D8D9  light blue 5
//0xFFDEEAEA  light blue
//0xFF263D43  dark blue
//0xFF47AEC6  light blue shine

class MyTheme {
  static Color mainPurpule = Color(0xFF453F84);
  static Color mainPink = const Color(0xFFBB83FF);
  static ThemeData them() {
    return ThemeData(
      scaffoldBackgroundColor: Color(0xFFC4D8D9),
      primaryColor: Colors.teal,
      colorScheme: ColorScheme.light(
        primary: const Color.fromARGB(255, 0, 0, 0),
        secondary: Colors.red,
        secondaryContainer: Colors.red,
        primaryContainer: Colors.pink,
        surfaceContainerLow: mainPurpule,
      ),
      inputDecorationTheme: InputDecorationTheme(
        floatingLabelAlignment: FloatingLabelAlignment.start,
        floatingLabelStyle: TextStyle(height: 50),
        labelStyle: TextStyle(color: Colors.black),
        contentPadding: EdgeInsets.all(5),
        errorStyle: TextStyle(height: 0),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
