/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todos/app/schedule_bloc/schedule_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_event.dart';
import 'package:todos/app/schedule_bloc/schedule_state.dart';
import 'package:todos/l10n/l10n.dart';
import 'package:todos/todos_overview/todo_bloc/todo_bloc.dart';
import 'package:todos/todos_overview/todos_overview.dart';
import 'package:todos/todos_overview/view/todos_overview_infinite_time_view.dart';
import 'package:todos/todos_overview/widgets/todos_overview_drawer.dart';
import 'package:todos_repository/todos_repository.dart';

class TodosOverviewPage extends StatelessWidget {
  const TodosOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TodosOverviewBloc(
            todosRepository: context.read<TodosRepository>(),
          )..add(const TodosOverviewSubscriptionRequested()),
        ),
        BlocProvider(
          create: (context) => TodoBloc(context.read<TodosRepository>()),
        ),
      ],
      child: TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  TodosOverviewView({super.key});

  final now = DateTime.now();
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    context
        .read<ScheduleBloc>()
        .add(const ScheduleCheckupStarted(duration: 60));

    return MultiBlocListener(
      listeners: [
        BlocListener<TodosOverviewBloc, TodosOverviewState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == TodosOverviewStatus.failure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(l10n.todosOverviewErrorSnackbarText),
                  ),
                );
              context.read<ScheduleBloc>().add(const ScheduleCheckupStopped());
            }
          },
        ),
        BlocListener<TodosOverviewBloc, TodosOverviewState>(
          listenWhen: (previous, current) =>
              previous.lastDeletedTodo != current.lastDeletedTodo &&
              current.lastDeletedTodo != null,
          listener: (context, state) {
            final deletedTodo = state.lastDeletedTodo!;
            final messenger = ScaffoldMessenger.of(context);
            messenger
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(
                    l10n.todosOverviewTodoDeletedSnackbarText(
                      deletedTodo.title,
                    ),
                  ),
                  action: SnackBarAction(
                    label: l10n.todosOverviewUndoDeletionButtonText,
                    onPressed: () {
                      messenger.hideCurrentSnackBar();
                      context
                          .read<TodosOverviewBloc>()
                          .add(const TodosOverviewUndoDeletionRequested());
                    },
                  ),
                ),
              );
          },
        ),
        BlocListener<ScheduleBloc, ScheduleState>(
          listener: (context, state) {
            if (state.status == ScheduleStatus.inProgress) {
              context.read<TodoBloc>().add(TodoSyncRequest());
            }
          },
        ),
      ],
      child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final size = MediaQuery.of(context).size;

          return TodosOverviewBackgroundBox(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              endDrawer: const TodosOverviewDrawer(),
              bottomNavigationBar: BottomAppBar(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        color: Colors.black,
                        icon: const Icon(Icons.list),
                      ),
                      IconButton(
                        onPressed: () {
                          log('canUndo: ${context.read<TodoBloc>().canUndo}');
                          context.read<TodoBloc>().undo();
                        },
                        color: Colors.black,
                        icon: const Icon(Icons.arrow_back),
                      ),
                      Text(
                        '${state.todos.filter((t) => t.date?.compareTo(now) == -1).length} Past',
                        style: theme.textTheme.caption?.copyWith(
                          color: Colors.grey,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  TodosOverviewInfiniteTimeView(
                    controller: _scrollController,
                    now: context.read<ScheduleBloc>().state.datetime,
                    padding: MediaQuery.of(context).padding.top,
                  ),
                  Positioned(
                      top: size.height -
                          size.height / 4 - 50,
                      width: size.width,
                      child: TodosDraftContainer(
                        todos:
                            state.todos.filter((e) => e.date == null).toList(),
                        height: size.height / 4,
                      )),
                  Container(
                    alignment: Alignment.topLeft,
                    height: 50,
                    child: TodosOverviewAppbar(
                      _scrollController,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
