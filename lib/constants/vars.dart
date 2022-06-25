import 'package:flutter/material.dart';

class Vars {

  static const EdgeInsetsGeometry listTilePadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);

  static ThemeData lightThemeData = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    //primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    // ListTile trailing icon color is grey
    primaryColor: Colors.blue,
    // tabbar active label
    indicatorColor: Colors.blue,
    // tabbar ind.
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      //color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 5,
        primary: Colors.blue,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius))),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, color: Colors.blue),
      ),
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white,
      elevation: 5,
    ),
    dividerTheme: const DividerThemeData(
      // It does not seem if you dont write thickness!
      thickness: 1,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      //fillColor: greyDarkTone,
      //filled: true,
      //contentPadding: EdgeInsets.zero,
      hintStyle: TextStyle(color: Colors.grey),
      labelStyle: TextStyle(color: Colors.grey),
      //contentPadding: EdgeInsets.zero,
      //fillColor: greyDarkTone,
      //filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
        borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(kRadialReactionRadius)),
      ),
    ),
    textTheme: const TextTheme(
      subtitle1: TextStyle(color: Colors.black), // ListTile-title
      caption: TextStyle(color: Colors.grey), // ListTile-subtitle
      bodyText2: TextStyle(color: Colors.black), // Normal text
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    chipTheme: const ChipThemeData(
      selectedColor: Colors.lightBlue,
      secondaryLabelStyle: TextStyle(color: Colors.white),
    ),
  );

}