/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todos/l10n/l10n.dart';
import 'package:todos/todos_overview/schedule_bloc/schedule_bloc.dart';
import 'package:todos/todos_overview/todo_bloc/todo_bloc.dart';
import 'package:todos/todos_overview/todos_overview.dart';
import 'package:todos/todos_overview/view/infinite_time_view/view/infinite_time_view.dart';
import 'package:todos/todos_overview/view/normal_view/todos_overview_nomarl_view.dart';
import 'package:todos/todos_overview/widgets/todos_overview_bottom_appbar.dart';
import 'package:todos/todos_overview/widgets/todos_overview_history_container.dart';
import 'package:todos_repository/todos_repository.dart';

import '../schedule_bloc/schedule_event.dart';
import '../schedule_bloc/schedule_state.dart';
import '../widgets/page_flip_builder.dart';

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
        BlocProvider(
          create: (context) => ScheduleBloc(),
        ),
      ],
      child: TodosOverviewView(),
    );
  }
}

class TodosOverviewView extends StatelessWidget {
  TodosOverviewView({super.key});

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
          final flipKey = GlobalKey<PageFlipBuilderState>();
          final historyTodos = state.todos.filter(
            (t) =>
                t.date
                    ?.compareTo(context.read<ScheduleBloc>().state.datetime) ==
                -1,
          );

          final views = [
            TodosOverviewInfiniteTimeView(
              controller: _scrollController,
              now: context.read<ScheduleBloc>().state.datetime,
              padding: MediaQuery.of(context).padding.top,
            ),
            TodosOverviewNormalView(
              controller: _scrollController,
              now: context.read<ScheduleBloc>().state.datetime,
              padding: MediaQuery.of(context).padding.top,
            )
          ];

          return Scaffold(
            backgroundColor: Colors.transparent,
            drawerScrimColor: Colors.transparent,
            drawer: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 80, left: 10),
                child: TodosOverviewHistoryContainer(
                  controller: _scrollController,
                  todos: historyTodos.toList(),
                ),
              ),
            ),
            // bottomSheet: draftContainer,
            bottomNavigationBar: TodosOverviewBottomAppBar(
              historyTodos: historyTodos.toList(),
              flipKey: flipKey,
            ),
            body: Stack(
              alignment: Alignment.topCenter,
              children: [
                // TodosOverviewInfiniteTimeView(
                //   controller: _scrollController,
                //   now: context.read<ScheduleBloc>().state.datetime,
                //   padding: MediaQuery.of(context).padding.top,
                // ),
                // TodosOverviewNormalView(
                //   controller: _scrollController,
                //   now: context.read<ScheduleBloc>().state.datetime,
                // ),
                // PageFlipBuilder(
                //   key: flipKey,
                //   interactiveFlipEnabled: false,
                //   frontBuilder: (context) => TodosOverviewInfiniteTimeView(
                //     controller: _scrollController,
                //     now: context.read<ScheduleBloc>().state.datetime,
                //     padding: MediaQuery.of(context).padding.top,
                //   ),
                //   backBuilder: (BuildContext context) =>
                //       TodosOverviewNormalView(
                //     controller: _scrollController,
                //     now: context.read<ScheduleBloc>().state.datetime,
                //     padding: MediaQuery.of(context).padding.top,
                //   ),
                // ),
                views[state.viewIndex],
                Container(
                  alignment: Alignment.topLeft,
                  height: 50 + MediaQuery.of(context).padding.top,
                  child: TodosOverviewAppbar(
                    _scrollController,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
