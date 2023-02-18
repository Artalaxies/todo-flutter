/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

class GeneralNotFoundPage extends StatelessWidget {
  const GeneralNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cruelty_free,
            size: 50,
            color: theme.colorScheme.error,
          ),
          const Text('Page Not Found.'),
        ],
      ),
    );
  }
}
