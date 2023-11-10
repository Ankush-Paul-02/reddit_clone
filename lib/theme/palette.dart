import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);

class Palette {
  static const blackColor = Color.fromRGBO(1, 1, 1, 1);
  static const greyColor = Color.fromRGBO(26, 39, 45, 1);
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  static var darkModeAppTheme = ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    colorScheme: const ColorScheme.dark(background: drawerColor),
  );

  static var lightModeAppTheme = ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    colorScheme: const ColorScheme.light(background: whiteColor),
  );
}

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeMode _mode;
  ThemeNotifier({ThemeMode mode = ThemeMode.dark})
      : _mode = mode,
        super(Palette.darkModeAppTheme) {
    getTheme();
  }

  ThemeMode get mode => _mode;

  void getTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final theme = preferences.getString('theme');

    if (theme == 'light') {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
    }
  }

  void toggleTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    if (_mode == ThemeMode.dark) {
      _mode = ThemeMode.light;
      state = Palette.lightModeAppTheme;
      preferences.setString('theme', 'light');
    } else {
      _mode = ThemeMode.dark;
      state = Palette.darkModeAppTheme;
      preferences.setString('theme', 'dark');
    }
  }
}
