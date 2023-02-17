/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GeneralPageNavigationRail extends StatelessWidget {
  const GeneralPageNavigationRail({super.key, this.rail, this.child});

  final Widget? rail;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 500,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: theme.drawerTheme.backgroundColor,
            ),
            child: rail,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 500,
            color: theme.backgroundColor,
            child: () {
              if (GoRouter.of(context).location == '/') {
                return Container();
              } else {
                return child ?? Container();
              }
            }(),
          ),
        ],
      ),
    );
  }
}
