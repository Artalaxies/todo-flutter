/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../view/general_default_page.dart';

class GeneralPageNavigationRail extends StatelessWidget {
  const GeneralPageNavigationRail({super.key, this.rail, this.child});

  final Widget? rail;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return rail != null
        ? Row(
            children: [
              Container(
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 2),
                  color: theme.drawerTheme.backgroundColor,
                ),
                child: rail,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 500,
                child: () {
                  if (GoRouter.of(context).location == '/') {
                    return const GeneralDefaultPage();
                  } else {
                    return Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: AppBar(
                        backgroundColor: theme.drawerTheme.backgroundColor,
                        automaticallyImplyLeading: false,
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            context.go('/');
                          },
                        ),
                      ),
                      body: child ?? const GeneralDefaultPage(),
                    );
                  }
                }(),
              ),
            ],
          )
        : child ?? const GeneralDefaultPage();
  }
}
