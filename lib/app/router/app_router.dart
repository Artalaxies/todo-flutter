/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/log_page/log_page.dart';
import 'package:todos/login/login.dart';
import 'package:todos/sign_up/sign_up.dart';
import 'package:todos/stats/view/stats_page.dart';
import 'package:todos/todos_overview/view/todos_overview_page.dart';

// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
// final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter goRouter({
 Widget Function(BuildContext context,
    GoRouterState state,
    Widget child,
    )? builder,}) => GoRouter(
    // navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        // navigatorKey: _shellNavigatorKey,
        builder: builder,
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const TodosOverviewPage(),
          ),
          GoRoute(
            path: '/todos',
            redirect: (context, state) => '/',
          ),
          GoRoute(
            path: '/stats',
            builder: (context, state) => const StatsPage(),
          ),
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
              path: '/signup',
              builder: (context, state) => const SignUpPage(),
          ),
          GoRoute(
            path: '/logs',
            builder: (context, state) => const LogPage(),
          )
        ],
      )
    ],
);
