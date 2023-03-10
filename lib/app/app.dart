/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

import '/app/router/app_router.dart';
import '/app/view/general_page_frame.dart';
import '/l10n/l10n.dart';
import '/theme/theme.dart';
import '../module.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Modularization.build(const AppView());
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter( builder:
          (context,state, child) {
            return GeneralPageFrame(page: child);
          },
      ),
      theme: FlutterTodosTheme.light,
      darkTheme: FlutterTodosTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
