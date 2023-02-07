/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:todos/todos_overview/widgets/page_flip_builder.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewBottomAppBar extends StatelessWidget {
  const TodosOverviewBottomAppBar({
    super.key,
    required this.flipKey,
    required this.historyTodos,
  });

  final List<Todo> historyTodos;
  final GlobalKey<PageFlipBuilderState> flipKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return BottomAppBar(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Builder(
              builder: (context) => MaterialButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(
                  Icons.history,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              historyTodos.length.toString(),
              style: theme.textTheme.caption?.copyWith(
                color: Colors.grey,
                fontSize: 40,
                fontWeight: FontWeight.w800,
              ),
            ),
            MaterialButton(
              onPressed: () {
                flipKey.currentState?.flip();
              },
              child: const Icon(
                Icons.compare_arrows,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
