/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewHistoryContainer extends StatelessWidget {
  const TodosOverviewHistoryContainer({
    super.key,
    required this.todos,
    required this.controller,
    this.hide = false,
  });

  final List<Todo> todos;
  final bool hide;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.width * 0.4,
        maxWidth: MediaQuery.of(context).size.width * 0.5,
        minWidth: 50,
      ),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return MaterialButton(
                    onPressed: () {
                      final currentContext = todos[index].key.currentContext;
                      final times = context
                              .read<ScheduleBloc>()
                              .state
                              .datetime
                              .difference(todos[index].date!)
                              .inMinutes ~/
                          5;
                      controller.animateTo(
                        -(84 * times).toDouble(),
                        duration: const Duration(seconds: 1),
                        curve: Curves.linear,
                      );
                      if (currentContext != null) {
                        Scrollable.ensureVisible(
                          todos[index].key.currentContext!,
                          duration: const Duration(seconds: 1),
                        );
                      }
                    },
                    child: Text(
                      todos[index].title,
                      style: const TextStyle(color: Colors.black),
                    ));
              },
              childCount: todos.length,
            ),
          )
        ],
      ),
    );
  }
}
