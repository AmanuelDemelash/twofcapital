
import 'package:flutter/material.dart';
import '../utils/colorConstant.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: "Roboto",
  //scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ColorConstant.primaryColor,
    brightness: Brightness.dark,
  ),
  cardTheme: const CardTheme(color: Colors.transparent,surfaceTintColor: Colors.transparent),
  // appBarTheme:const AppBarTheme(
  //   backgroundColor: Colors.white,
  //   centerTitle: false,
  //     surfaceTintColor: Colors.transparent
  // ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: ColorConstant.primaryColor,
    )
  ),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);