/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos/todos_overview/widgets/todo_list_tile.dart';
import 'package:todos_repository/todos_repository.dart';

class InfiniteTimeViewDraftContainer extends StatelessWidget {
  const InfiniteTimeViewDraftContainer(
      {super.key, required this.todos, this.height});

  final List<Todo> todos;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 200),
      height: height,
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        color: const Color(0xaaFFF06F),
        border: Border.all(color: Colors.black54, width: 5),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...todos
                  .map(
                    (todo) => TodoListTile(
                      todo: todo,
                      onToggleCompleted: (isCompleted) {
                        context.read<TodosOverviewBloc>().add(
                              TodosOverviewTodoCompletionToggled(
                                todo: todo,
                                isCompleted: isCompleted,
                              ),
                            );
                      },
                      onDismissed: (_) {
                        context
                            .read<TodosOverviewBloc>()
                            .add(TodosOverviewTodoDeleted(todo));
                      },
                    ),
                  )
                  .toList(),
              Center(
                child: IconButton(
                  onPressed: () => context
                      .read<TodosOverviewBloc>()
                      .add(const TodosOverviewTodoAddRequested()),
                  color: Colors.blue,
                  icon: const Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
