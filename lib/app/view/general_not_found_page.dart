/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

class GeneralNotFoundPage extends StatelessWidget {
  const GeneralNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(
          Icons.cruelty_free,
          size: 50,
        ),
        Text('Page Not Found.'),
      ],
    );
  }
}
