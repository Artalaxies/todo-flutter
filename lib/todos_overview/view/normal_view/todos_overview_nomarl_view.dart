/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todos/todos_overview/todos_overview.dart';
import 'package:todos/todos_overview/view/infinite_time_view/bloc/infinite_time_view_bloc.dart';

class TodosOverviewNormalView extends StatelessWidget {
  const TodosOverviewNormalView({
    super.key,
    required this.controller,
    required this.now,
    this.padding = 0,
  });

  final DateTime now;
  final ScrollController controller;
  final double padding;

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => InfiniteTimeViewCubit(now),
        child: _TodosOverviewInfiniteTimeView(
          key: key,
          controller: controller,
          padding: padding,
          now: now,
        ),
      );
}

class _TodosOverviewInfiniteTimeView extends StatelessWidget {
  const _TodosOverviewInfiniteTimeView({
    super.key,
    required this.now,
    required this.controller,
    this.padding = 0,
  });

  final DateTime now;
  final ScrollController controller;
  final double padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final captionTextStyle = theme.textTheme.caption?.getTextStyle() ??
        ui.TextStyle(color: Colors.blue);
    final todos = context.read<TodosOverviewBloc>().state.todos
      ..sort((ta, tb) {
        if (ta.date == null) {
          return 0;
        } else if (tb.date == null) {
          return 1;
        } else {
          return -ta.date!.compareTo(tb.date!);
        }
      });
    final hisTodos = todos.filter((t) => t.isCompleted).toList();
    final undoTodos = todos.filter((t) => !t.isCompleted).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => context
            .read<TodosOverviewBloc>()
            .add(const TodosOverviewTodoAddRequested()),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50 + padding),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: CustomScrollView(
              shrinkWrap: true,
              controller: controller,
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate([
                    ...Iterable.generate(
                      undoTodos.length,
                      (index) {
                        return TodoListTile(
                          key: undoTodos[index].key,
                          todo: undoTodos[index],
                        );
                      },
                    ),
                    ExpansionPanelList.radio(
                      animationDuration: const Duration(milliseconds: 500),
                      dividerColor: Colors.transparent,
                      elevation: 0,
                      children: [
                        ExpansionPanelRadio(
                          value: 0,
                          canTapOnHeader: true,
                          backgroundColor: Colors.transparent,
                          headerBuilder: (context, isOpen) => Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${hisTodos.length} Completed Items',
                                style: theme.textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          body: ListView.builder(
                            shrinkWrap: true,
                            controller: controller,
                            itemBuilder: (context, index) {
                              return TodoListTile(
                                key: hisTodos[index].key,
                                todo: hisTodos[index],
                              );
                            },
                            itemCount: hisTodos.length,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
