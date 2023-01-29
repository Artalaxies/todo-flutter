/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:developer' as d;
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_state.dart';
import 'package:todos/todos_overview/bloc/infinite_time_view_bloc.dart';
import 'package:todos/todos_overview/widgets/todo_datetime_box.dart';

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

    return BlocListener<ScheduleBloc, ScheduleState>(
      listener: (context, state) {
        if (state.status == ScheduleStatus.inProgress) {
          context.read<InfiniteTimeViewCubit>().update(state.datetime);
        }
      },
      child: BlocBuilder<InfiniteTimeViewCubit, InfiniteTimeViewState>(
        builder: (context, state) {
          return ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              controller: controller,
              center: centerKey,
              reverse: true,
              anchor: 0.49 + (padding > 0 ? 0.015 : 0),
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return TodoDateTimeBox(
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
                      return TodoDateTimeBox(
                        date: state.now.add(Duration(minutes: (index + 1) * 5)),
                        textStyle: captionTextStyle,
                        now: state.now,
                      );
                    },
                    childCount: state.futureTimeCount,
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
