/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todos/l10n/l10n.dart';

class LogPage extends StatelessWidget {
  const LogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      controller: ScrollController(),
      child: FutureBuilder(
        future: rootBundle.loadString('CHANGELOG.md'),
        builder: (context, snapshot) {
          return Text(snapshot.data ?? '');
        },
      ),
    );
  }
}
