import 'package:flutter/material.dart';

ThemeData viragoTheme() {
  TextTheme _basicTextTheme(TextTheme base) {
    return base.copyWith(
        headline6: base.headline6.copyWith(
          fontFamily: 'Oswald',
          fontSize: 15.0,
          color: Colors.black
        ),
        headline5: base.headline5.copyWith(
          fontFamily: 'Oswald',
          fontSize: 22.0,
          color: Colors.black,
        ),
        headline4: base.headline4.copyWith(
          fontFamily: 'Oswald',
          fontSize: 30.0,
          color: Colors.black,
        ),
        headline3: base.headline3.copyWith(
          fontFamily: 'Oswald',
          fontSize: 35.0,
          color: Colors.black,
        ),
        headline2: base.headline2.copyWith(
          fontFamily: 'Oswald',
          fontSize: 65.0,
          color: Colors.black87,
        ),
        caption: base.caption.copyWith(
          color: Colors.black38,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
        bodyText2: base.bodyText2.copyWith(color: Color(0xFF807A6B)));
  }
  final ThemeData base = ThemeData.light();
  return base.copyWith(
      textTheme: _basicTextTheme(base.textTheme),
      //textTheme: Typography().white,
      primaryColor: Color(0xffce107c),
      //primaryColor: Color(0xff4829b2),
      indicatorColor: Color(0xFF807A6B),
      scaffoldBackgroundColor: Color(0xFFF5F5F5),
      accentColor: Color(0xFFFFF8E1),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20.0,
      ),
      buttonColor: Colors.white,
      backgroundColor: Colors.white,
      tabBarTheme: base.tabBarTheme.copyWith(
        labelColor: Color(0xffce107c),
        unselectedLabelColor: Colors.grey,
      ));
} 