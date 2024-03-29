/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

class GeneralDefaultPage extends StatelessWidget {
  const GeneralDefaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.adjust_rounded,
            size: 50,
            color: theme.colorScheme.secondary,
          ),
          Text(
            'Do Something?',
            style: TextStyle(color: theme.colorScheme.secondary),
          ),
        ],
      ),
    );
  }
}
