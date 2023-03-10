/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';

class GeneralPageEndDrawer extends StatelessWidget {
  const GeneralPageEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
        top: 50 + MediaQuery.of(context).padding.top,
        bottom: 100,
        right: 20,
      ),
      constraints: const BoxConstraints(
        maxWidth: 400,
        minWidth: 200,
      ),
      child: ColoredBox(
        color: theme.colorScheme.secondary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...context.read<GeneralUserBloc>().state.user.isEmpty
                ? [
                    ListTile(
                      title: const Text('Sign In'),
                      selectedColor: Colors.white12,
                      onTap: () {
                        context.go('/login');
                      },
                    ),
            ]
                : [
              ListTile(
                title: const Text('logout'),
                      selectedColor: Colors.white12,
                      onTap: () {
                        context
                            .read<GeneralUserBloc>()
                            .add(const GeneralUserLogoutRequested());
                      },
                    ),
            ],
            ListTile(
              title: const Text('Integrations'),
              selectedColor: Colors.white12,
              onTap: () {
                context.go('/integrations');
              },
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => ListTile(
                title: Text(
                  'v${snapshot.data?.version ?? '0.0.0'}',
                ),
                selectedColor: Colors.white12,
                onTap: () {
                  context.go('/logs');
                },
              ),
            ),
            ListTile(
              title: const Text('Suggest'),
              selectedColor: Colors.white12,
              onTap: () {
                context.go('/suggest');
              },
            ),
          ],
        ),
      ),
    );
  }
}
