/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos/todos_overview/todo_bloc/todo_bloc.dart';
import 'package:todos/todos_overview/widgets/todos_overview_draft_container.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewBottomAppBar extends StatelessWidget {
  const TodosOverviewBottomAppBar({
    super.key,
    required this.historyTodos,
  });

  final List<Todo> historyTodos;

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
            MaterialButton(
              onPressed: () {
                Scaffold.of(context).showBottomSheet(
                  (contexts) => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ColoredBox(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.of(contexts).pop();
                                },
                                color: Colors.grey,
                                child: const Icon(
                                  Icons.list,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  log('canUndo: ${context.read<TodoBloc>().canUndo}');
                                  context.read<TodoBloc>().undo();
                                },
                                color: Colors.black,
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: BlocProvider.of<TodosOverviewBloc>(
                              context,
                            ),
                          ),
                          BlocProvider.value(
                              value: BlocProvider.of<TodoBloc>(context)),
                        ],
                        child:
                            BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
                          builder: (context, state) => TodosDraftContainer(
                            todos: state.todos
                                .filter((e) => e.date == null)
                                .toList(),
                            height: size.height / 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Icon(
                Icons.list,
                color: Colors.black,
              ),
            ),
            Builder(
              builder: (context) => MaterialButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Text(
                  historyTodos.length.toString(),
                  style: theme.textTheme.caption?.copyWith(
                    color: Colors.grey,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {},
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
