/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:developer' as d;
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todos/todos_overview/schedule_bloc/schedule_bloc.dart';
import 'package:todos/todos_overview/view/infinite_time_view/bloc/infinite_time_view_bloc.dart';
import 'package:todos/todos_overview/view/infinite_time_view/widgets/infinite_time_view_list_item.dart';

import '../../../bloc/todos_overview_bloc.dart';
import '../../../schedule_bloc/schedule_state.dart';
import '../../../todo_bloc/todo_bloc.dart';
import '../widgets/infinite_time_view_background_container.dart';
import '../widgets/infinite_time_view_draft_container.dart';

class TodosOverviewInfiniteTimeView extends StatelessWidget {
  const TodosOverviewInfiniteTimeView({
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

  bool get _isTop {
    if (!controller.hasClients) return false;
    final minScroll = controller.position.minScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll <= (minScroll * 0.9);
  }

  bool get _isBottom {
    if (!controller.hasClients) return false;
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const centerKey = ValueKey('central-sliver-list');
    final captionTextStyle = theme.textTheme.caption?.getTextStyle() ??
        ui.TextStyle(color: Colors.blue);

    void _onScroll() {
      if (_isBottom) {
        d.log('is bottom');
        context.read<InfiniteTimeViewCubit>().addMoreFutureTime();
      }

      if (_isTop) {
        d.log('is top');
        context.read<InfiniteTimeViewCubit>().addMorePastTime();
      }
    }

    controller.addListener(_onScroll);

    return InfiniteTimeViewBackgroundContainer(
      child: BlocListener<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state.status == ScheduleStatus.inProgress) {
            context.read<InfiniteTimeViewCubit>().update(state.datetime);
          }
        },
        child: BlocBuilder<InfiniteTimeViewCubit, InfiniteTimeViewState>(
          builder: (context, state) {
            final size = MediaQuery.of(context).size;

            return Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    color: Colors.black,
                    onPressed: () {
                      controller.animateTo(
                        0,
                        duration: Duration(
                          milliseconds:
                              min(controller.offset.abs() / 0.59, 5000).toInt(),
                        ),
                        curve: Curves.easeInOutQuart,
                      );
                    },
                    icon: const Icon(Icons.adjust_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      Scaffold.of(context).showBottomSheet(
                        (contexts) => Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ColoredBox(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(contexts).pop();
                                      },
                                      child: const Icon(
                                        Icons.arrow_downward,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        d.log(
                                            'canUndo: ${context.read<TodoBloc>().canUndo}');
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
                              child: BlocBuilder<TodosOverviewBloc,
                                  TodosOverviewState>(
                                builder: (context, state) =>
                                    InfiniteTimeViewDraftContainer(
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
                    icon: const Icon(
                      Icons.list,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  controller: controller,
                  center: centerKey,
                  reverse: true,
                  anchor: 0.4875 + (padding > 0 ? -0.009 : 0),
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return TodoDateTimeListItem(
                            date: state.now
                                .subtract(Duration(minutes: index * 5)),
                            textStyle: captionTextStyle,
                            now: state.now,
                          );
                        },
                        childCount: state.pastTimeCount,
                      ),
                    ),
                    SliverList(
                      key: centerKey,
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return TodoDateTimeListItem(
                            date: state.now
                                .add(Duration(minutes: (index + 1) * 5)),
                            textStyle: captionTextStyle,
                            now: state.now,
                          );
                        },
                        childCount: state.futureTimeCount,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
