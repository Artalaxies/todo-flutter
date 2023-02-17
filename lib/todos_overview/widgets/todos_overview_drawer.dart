/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';

class TodosOverviewDrawer extends StatelessWidget {
  const TodosOverviewDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: EdgeInsets.only(
        top: 50 + MediaQuery.of(context).padding.top,
        bottom: 100,
        right: 20,
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      child: ColoredBox(
        color: Colors.white54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Sign In'),
              onTap: () {
                if (context.read<GeneralUserBloc>().state.user.isEmpty) {
                  context.go('/login');
                }
              },
            ),
            ListTile(
              title: const Text('Integrations'),
              onTap: () {},
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) => ListTile(
                title: Text(
                  'v${snapshot.data?.version ?? '0.0.0'}',
                ),
                onTap: () {
                  if (context.read<GeneralUserBloc>().state.user.isEmpty) {
                    context.go('/logs');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
