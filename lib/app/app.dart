/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/app_bloc_provider.dart';
import 'package:todos/app/router/app_router.dart';
import 'package:todos/app/view/general_page_frame.dart';
import 'package:todos/l10n/l10n.dart';
import 'package:todos/theme/theme.dart';

class App<T> extends StatelessWidget {
  const App({super.key,
    required this.repositoryProviders,});

  final List<RepositoryProvider<T>> repositoryProviders;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: repositoryProviders,
      child: appBlocProviders(const AppView()),
    );
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
