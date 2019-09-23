import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData appThemeData() {
  final base = ThemeData.light();
  return base.copyWith(
    tabBarTheme: base.tabBarTheme.copyWith(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: appYellow, width: 2.0),
        // insets: EdgeInsets.symmetric(horizontal: 10.0),
      ),
      labelColor: appBlack,
      labelStyle: base.textTheme.headline.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'OpenSans',),
      unselectedLabelStyle: base.textTheme.body1.copyWith(color: Colors.white, fontWeight: FontWeight.w900, fontFamily: 'OpenSans',),
    ),
    brightness: Brightness.light,
    accentColor: army,
    primaryColor: white,
    buttonTheme: base.buttonTheme.copyWith(
      padding: EdgeInsets.symmetric(vertical: 20.0,),
      buttonColor: appGreen,
      textTheme: ButtonTextTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: appGreen,
      foregroundColor: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    cardColor: Colors.white,
    // textSelectionColor: shedAppSelectionBlack,
    // errorColor: shedAppErrorRed,
    textTheme: base.textTheme
        .copyWith(
          headline: TextStyle(
            fontFamily: "PlayfairDisplay",
            // fontSize: 40.0,
          ),
          title: TextStyle(
            fontFamily: 'OpenSans',
            // fontSize: 20.0,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
            // fontSize: 20.0,
            color: appWhite,
          ),
          subtitle: TextStyle(
            fontFamily: 'OpenSans',
            // fontSize: 18.0,
          ),
          body1: TextStyle(
            fontFamily: "OpenSans",
            // fontSize: 16.0,
          ),
          display1: TextStyle(
            fontFamily: "OpenSans",
            // fontSize: 23.0,
          ),
          caption: TextStyle(
            fontFamily: "OpenSans",
            // fontSize: 14.0,
          ),
        )
        .apply(
          displayColor: appBlack,
          bodyColor: appBlack,
        ),
    primaryIconTheme: base.iconTheme.copyWith(
      size: 30,
      color: appGreen,
    ),
    indicatorColor: appGreen,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(
        vertical: 25.0,
        horizontal: 10.0,
      ),
      isDense: true,
      filled: true,
      fillColor: formInputGreen,
      suffixStyle: TextStyle(color: appGreen),
      prefixStyle: TextStyle(color: appGreen),
      labelStyle: TextStyle(
        color: Colors.grey,
        fontFamily: "OpenSans",
      ),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontFamily: "OpenSans",
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0x00),
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0x00),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0x00),
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0x00),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        borderSide: BorderSide(
          color: Color(0x00),
        ),
      ),
    ),
    iconTheme: base.iconTheme.copyWith(
      color: appGrey,
      size: 30,
    ),
  );
}
