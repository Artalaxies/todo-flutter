/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

class FlutterTodosTheme {
  static ThemeData get light {
    return ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF13B9FF),
        ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: const Color(0xFFE8E0C2),
          backgroundColor: const Color(0xFFC0B89E),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFFE8E0C2)),
        toggleableActiveColor: const Color(0xFF13B9FF),
        backgroundColor: const Color(0xFFC0B89E));
  }

  static ThemeData get dark {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: Color(0xFF13B9FF),
      ),
      colorScheme: ColorScheme.fromSwatch(
        brightness: Brightness.dark,
        accentColor: const Color(0xFF13B9FF),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      toggleableActiveColor: const Color(0xFF13B9FF),
    );
  }
}
