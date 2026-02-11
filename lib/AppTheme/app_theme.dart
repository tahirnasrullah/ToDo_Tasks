import 'package:flutter/material.dart';

class AppTheme {
  AppTheme();

  static ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.light,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.black,
      )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.deepPurpleAccent.shade700,
      unselectedItemColor: Colors.grey,
    )

  );

  static ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.deepPurple,
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    ),
      textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.grey,
          ),

      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      unselectedItemColor: Colors.white,
    )
  );
}
