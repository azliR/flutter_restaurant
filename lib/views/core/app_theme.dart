// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/views/core/misc/constants.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:md2_tab_indicator/md2_tab_indicator.dart';

class AppTheme {
  AppTheme._();

  static final _darkPrimaryColor = Colors.blue.shade200;
  static final _darkSecondaryColor = Colors.blue.shade800;
  static const _darkOnPrimaryColor = Colors.black;
  static const _darkOnSecondaryColor = Colors.black;
  static const _darkErrorColor = Color(0xffCF6679);
  static final _darkCardColor = Color(0xff323230);
  static final _darkBackgroundColor = Color(0xff1E1E1E);
  static final _darkAppBarBackgroundColor = _darkBackgroundColor;
  static final _darkBottomNavBarBackgroundColor = Colors.grey[850]!;
  static const _darkTextColor = Colors.white;

  static final _lightPrimaryColor = Colors.blue.shade800;
  static final _lightSecondaryColor = Colors.blue.shade200;
  static const _lightOnPrimaryColor = Colors.white;
  static const _lightOnSecondaryColor = Colors.white;
  static const _lightErrorColor = Color(0xffB00020);
  static final _lightCardColor = Colors.blue.shade50;
  static const _lightBackgroundColor = Colors.white;
  static final _lightAppBarBackgroundColor = _lightBackgroundColor;
  static final _lightBottomNavBarBackgroundColor = _lightCardColor;
  static const _lightTextColor = Colors.black87;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    primaryColor: _darkPrimaryColor,
    errorColor: _darkErrorColor,
    backgroundColor: _darkBackgroundColor,
    scaffoldBackgroundColor: _darkBackgroundColor,
    cardColor: _darkCardColor,
    splashColor: _darkPrimaryColor.withOpacity(0.2),
    highlightColor: _darkPrimaryColor.withOpacity(0.2),
    bottomAppBarColor: _darkAppBarBackgroundColor,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: _darkSecondaryColor,
      surface: _darkCardColor,
      background: _darkBackgroundColor,
      onPrimary: _darkOnPrimaryColor,
      onSecondary: _darkOnSecondaryColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: _darkSecondaryColor,
      selectionHandleColor: _darkPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _darkSecondaryColor,
    ),
    snackBarTheme: _snackBarTheme,
    dialogTheme: _dialogTheme,
    buttonTheme: _buttonTheme,
    popupMenuTheme: _popupMenuThemeData,
    inputDecorationTheme: _inputDecorationTheme(brightness: Brightness.dark),
    elevatedButtonTheme: _elevatedButtonTheme(brightness: Brightness.dark),
    outlinedButtonTheme: _outlinedButtonTheme(brightness: Brightness.dark),
    textButtonTheme: _textButtonTheme(brightness: Brightness.dark),
    appBarTheme: _appBarTheme(brightness: Brightness.dark),
    tabBarTheme: _tabBarTheme(brightness: Brightness.dark),
    chipTheme: _chipTheme(brightness: Brightness.dark),
    textTheme: _textTheme(brightness: Brightness.dark),
    radioTheme: _radioThemeData(brightness: Brightness.dark),
    bottomNavigationBarTheme:
        _bottomNavigationTheme(brightness: Brightness.dark),
    scrollbarTheme: _scrollbarThemeData(brightness: Brightness.dark),
    navigationRailTheme: _navigationRailTheme(brightness: Brightness.dark),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _lightPrimaryColor,
    errorColor: _lightErrorColor,
    backgroundColor: _lightBackgroundColor,
    scaffoldBackgroundColor: _lightBackgroundColor,
    cardColor: _lightCardColor,
    splashColor: _lightPrimaryColor.withOpacity(0.2),
    highlightColor: _lightPrimaryColor.withOpacity(0.2),
    bottomAppBarColor: _lightAppBarBackgroundColor,
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: _lightSecondaryColor,
      surface: _lightCardColor,
      background: _lightBackgroundColor,
      onPrimary: _lightOnPrimaryColor,
      onSecondary: _lightOnSecondaryColor,
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: _lightSecondaryColor,
      selectionHandleColor: _lightPrimaryColor,
    ),
    iconTheme: IconThemeData(
      color: _lightSecondaryColor,
    ),
    snackBarTheme: _snackBarTheme,
    dialogTheme: _dialogTheme,
    buttonTheme: _buttonTheme,
    popupMenuTheme: _popupMenuThemeData,
    inputDecorationTheme: _inputDecorationTheme(brightness: Brightness.light),
    elevatedButtonTheme: _elevatedButtonTheme(brightness: Brightness.light),
    outlinedButtonTheme: _outlinedButtonTheme(brightness: Brightness.light),
    textButtonTheme: _textButtonTheme(brightness: Brightness.light),
    appBarTheme: _appBarTheme(brightness: Brightness.light),
    tabBarTheme: _tabBarTheme(brightness: Brightness.light),
    chipTheme: _chipTheme(brightness: Brightness.light),
    textTheme: _textTheme(brightness: Brightness.light),
    radioTheme: _radioThemeData(brightness: Brightness.light),
    bottomNavigationBarTheme:
        _bottomNavigationTheme(brightness: Brightness.light),
    scrollbarTheme: _scrollbarThemeData(brightness: Brightness.light),
  );

  static const _snackBarTheme = SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
  );

  static const _dialogTheme = DialogTheme(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
  );

  static const _buttonTheme = ButtonThemeData(
    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
    textTheme: ButtonTextTheme.primary,
  );

  static const _popupMenuThemeData = PopupMenuThemeData(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
  );

  static ScrollbarThemeData _scrollbarThemeData({
    required Brightness brightness,
  }) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkSecondaryColor;
        break;
      case Brightness.light:
        color = _lightSecondaryColor;
        break;
    }
    return ScrollbarThemeData(
      radius: const Radius.circular(8),
      thumbColor: MaterialStateProperty.all(color),
    );
  }

  static RadioThemeData _radioThemeData({
    required Brightness brightness,
  }) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkPrimaryColor;
        break;
      case Brightness.light:
        color = _lightPrimaryColor;
        break;
    }
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(color),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({
    required Brightness brightness,
  }) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkCardColor;
        break;
      case Brightness.light:
        color = _lightCardColor;
        break;
    }
    return InputDecorationTheme(
      filled: true,
      fillColor: color,
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme({
    required Brightness brightness,
  }) {
    final Color primaryColor;

    switch (brightness) {
      case Brightness.dark:
        primaryColor = _darkPrimaryColor;
        break;
      case Brightness.light:
        primaryColor = _lightPrimaryColor;
        break;
    }
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: primaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme({
    required Brightness brightness,
  }) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkPrimaryColor;
        break;
      case Brightness.light:
        color = _lightPrimaryColor;
        break;
    }
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))),
      ).copyWith(
        side: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return BorderSide(
                color: color,
              );
            }
            return null;
          },
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme({
    required Brightness brightness,
  }) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkPrimaryColor;
        break;
      case Brightness.light:
        color = _lightPrimaryColor;
        break;
    }
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  static AppBarTheme _appBarTheme({required Brightness brightness}) {
    const elevation = 0.0;

    final Color color;
    final IconThemeData iconTheme;
    final textTheme = _textTheme(brightness: brightness);

    switch (brightness) {
      case Brightness.dark:
        iconTheme = IconThemeData(color: _darkSecondaryColor);
        color = _darkAppBarBackgroundColor;
        break;
      case Brightness.light:
        iconTheme = IconThemeData(color: _lightSecondaryColor);
        color = _lightAppBarBackgroundColor;
        break;
    }

    return AppBarTheme(
      elevation: elevation,
      color: MaterialStateColor.resolveWith((Set<MaterialState> states) {
        return states.contains(MaterialState.scrolledUnder)
            ? Color.alphaBlend(Colors.white10, color)
            : color;
      }),
      iconTheme: iconTheme,
      titleTextStyle: textTheme.headline6,
    );
  }

  static TabBarTheme _tabBarTheme({required Brightness brightness}) {
    final Color labelColor;
    final Color indicatorColor;

    switch (brightness) {
      case Brightness.dark:
        labelColor = _darkPrimaryColor;
        indicatorColor = _darkSecondaryColor;
        break;
      case Brightness.light:
        labelColor = _lightPrimaryColor;
        indicatorColor = _lightSecondaryColor;
        break;
    }
    return TabBarTheme(
      labelColor: labelColor,
      labelStyle: _textTheme(brightness: brightness).subtitle2,
      unselectedLabelStyle: _textTheme(brightness: brightness).subtitle2,
      indicatorSize: TabBarIndicatorSize.label,
      // indicator: MD2Indicator(
      //   indicatorHeight: 4,
      //   indicatorColor: indicatorColor,
      //   indicatorSize: MD2IndicatorSize.normal,
      // ),
    );
  }

  static ChipThemeData _chipTheme({required Brightness brightness}) {
    final Color color;

    switch (brightness) {
      case Brightness.dark:
        color = _darkPrimaryColor;
        break;
      case Brightness.light:
        color = _lightPrimaryColor;
        break;
    }
    const textLabelAlpha = 0xde; // 87%
    final primaryColor =
        brightness == Brightness.light ? Colors.black : Colors.white;
    final labelStyle = TextStyle(color: primaryColor.withAlpha(textLabelAlpha));

    return ChipThemeData.fromDefaults(
      brightness: brightness,
      secondaryColor: color,
      labelStyle: labelStyle,
    );
  }

  static BottomNavigationBarThemeData _bottomNavigationTheme({
    required Brightness brightness,
  }) {
    final Color selectedColor;
    final Color unselectedColor;
    final Color backgroundColor;

    switch (brightness) {
      case Brightness.dark:
        selectedColor = Colors.grey.shade200;
        unselectedColor = Colors.grey.shade400;
        backgroundColor = _darkBottomNavBarBackgroundColor;
        break;
      case Brightness.light:
        selectedColor = Colors.grey.shade900;
        unselectedColor = Colors.grey.shade800;
        backgroundColor = _lightBottomNavBarBackgroundColor;
        break;
    }

    return BottomNavigationBarThemeData(
      backgroundColor: backgroundColor,
      selectedItemColor: selectedColor,
      selectedLabelStyle: _textTheme(brightness: brightness)
          .subtitle2
          ?.copyWith(color: selectedColor),
      unselectedItemColor: unselectedColor,
      unselectedLabelStyle: _textTheme(brightness: brightness)
          .subtitle2
          ?.copyWith(color: unselectedColor),
    );
  }

  static NavigationRailThemeData _navigationRailTheme({
    required Brightness brightness,
  }) {
    final Color selectedColor;
    final Color unselectedColor;

    switch (brightness) {
      case Brightness.dark:
        selectedColor = Colors.grey.shade200;
        unselectedColor = Colors.grey.shade400;
        break;
      case Brightness.light:
        selectedColor = Colors.grey.shade900;
        unselectedColor = Colors.grey.shade800;
        break;
    }

    return NavigationRailThemeData(
      labelType: NavigationRailLabelType.all,
      selectedIconTheme: IconThemeData(color: selectedColor),
      unselectedIconTheme: IconThemeData(color: unselectedColor),
      selectedLabelTextStyle: _textTheme(brightness: brightness)
          .subtitle2
          ?.copyWith(color: selectedColor),
      unselectedLabelTextStyle: _textTheme(brightness: brightness)
          .subtitle2
          ?.copyWith(color: unselectedColor),
    );
  }

  static TextTheme _textTheme({required Brightness brightness}) {
    final Color bodyColor;
    final Color displayColor;

    switch (brightness) {
      case Brightness.dark:
        displayColor = _darkTextColor;
        bodyColor = _darkTextColor;
        break;
      case Brightness.light:
        displayColor = _lightTextColor;
        bodyColor = _lightTextColor;
        break;
    }

    return TextTheme(
      headline1: GoogleFonts.poppins(
        fontSize: 93,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
      ),
      headline2: GoogleFonts.poppins(
        fontSize: 58,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
      ),
      headline3: GoogleFonts.poppins(
        fontSize: 46,
        fontWeight: FontWeight.w400,
      ),
      headline4: GoogleFonts.poppins(
        fontSize: 33,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      headline5: GoogleFonts.poppins(
        fontSize: 23,
        fontWeight: FontWeight.w400,
      ),
      headline6: GoogleFonts.poppins(
        fontSize: 19,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
      ),
      subtitle1: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
      ),
      subtitle2: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      bodyText1: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
      ),
      bodyText2: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
      ),
      button: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
      ),
      caption: GoogleFonts.roboto(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
      overline: GoogleFonts.roboto(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
      ),
    ).apply(
      bodyColor: bodyColor,
      displayColor: displayColor,
    );
  }
}
