/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewHistoryContainer extends StatelessWidget {
  const TodosOverviewHistoryContainer(
      {super.key, required this.todos, this.hide = false});

  final List<Todo> todos;
  final bool hide;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.width * 0.4,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Text(
                  todos[index].title,
                  style: const TextStyle(color: Colors.black),
                );
              },
              childCount: todos.length,
            ),
          )
        ],
      ),
    );
  }
}
