import 'package:flutter/material.dart';
import 'package:vault/SomeConstants.dart';
import 'package:vault/pages/homePage.dart';
import 'package:vault/pages/loginPage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: BACKGROUNDCOLOR,
        popupMenuTheme: PopupMenuThemeData(color: DARKBACKGROUND),

        appBarTheme: AppBarTheme(
          backgroundColor: DARKBACKGROUND,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: DARKBACKGROUND,
          selectedItemColor: GREENFOREGROUND,
          unselectedItemColor: GREYTEXT,
        ),
        textTheme: TextTheme(
          displayLarge: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
        ),
        dialogTheme: DialogThemeData(backgroundColor: BACKGROUNDCOLOR),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
