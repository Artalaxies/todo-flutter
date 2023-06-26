/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

const _avatarSize = 15.0;

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.photo});

  final String? photo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photo = this.photo;

    return CircleAvatar(
      radius: _avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? Icon(
              Icons.person_outline,
              size: _avatarSize,
              color: theme.appBarTheme.foregroundColor,
            )
          : null,
    );
  }
}
