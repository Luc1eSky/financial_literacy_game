import 'package:flutter/material.dart';

// light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true, // use material 3 design for all design elements
  //colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
  //fontFamily: 'Georgia', // define the default text family
  // textTheme: const TextTheme(
  //   titleLarge: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
  //   titleSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //   labelLarge: TextStyle(fontSize: 20),
  // ),
);

// dark theme is a copy of light theme with specific modifications
ThemeData darkTheme = lightTheme.copyWith(
  brightness: Brightness.dark,
);
