/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:developer';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todos/app/schedule_bloc/schedule_bloc.dart';
import 'package:todos/app/schedule_bloc/schedule_state.dart';
import 'package:todos/todos_overview/bloc/todos_overview_bloc.dart';
import 'package:todos/todos_overview/widgets/todo_list_tile.dart';
import 'package:todos_repository/todos_repository.dart';

class TodoDateTimeBox extends StatelessWidget {
  TodoDateTimeBox({
    super.key,
    required this.date,
    required this.now,
    ui.TextStyle? textStyle,
  }) {
    _textStyle = textStyle ?? ui.TextStyle(color: Colors.black);
  }

  final DateTime date;

  final DateTime now;
  late final ui.TextStyle _textStyle;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ScheduleBloc, ScheduleState>(
        builder: (context, scheduleState) =>
            BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            List<Todo> _todosForFiveMinutes(DateTime date) {
              return state.todos
                  .where(
                    (element) {
                      if (element.date != null) {
                        return element.date!.difference(date).inDays == 0 &&
                            element.date!.difference(date).inMinutes >= -5 &&
                            element.date!.difference(date).inMinutes < 0;
                      } else {
                        return false;
                      }
                    },
                  )
                  .toList()
                  .reversed
                  .toList();
            }

            final range =
                scheduleState.datetime.difference(now).inMinutes.abs() ~/ 5;
            final updatedDate = date.add(Duration(minutes: range * 5));

            return CustomPaint(
              foregroundPainter: TimeRulerCustomPainter(
                  captionTextStyle: _textStyle,
                  date: updatedDate,
                  now: now,
                  stateTime: context.read<ScheduleBloc>().state.datetime
                  // now: scheduleState.datetime,
                  ),
              isComplex: true,
              willChange: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 64),
                  child: Column(
                    children: [
                      ..._todosForFiveMinutes(updatedDate).map(
                        (e) => TodoListTile(
                          todo: e,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class TimeRulerCustomPainter extends CustomPainter {
  TimeRulerCustomPainter({
    required this.captionTextStyle,
    required this.date,
    required this.now,
    required this.stateTime,
  }) : super();
  final DateTime date;
  final DateTime now;
  final DateTime stateTime;
  final ui.TextStyle captionTextStyle;
  final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  final DateFormat timeFormatter = DateFormat('HH:mm');

  @override
  void paint(Canvas canvas, Size size) {
    final diffNow = now.difference(stateTime).inMinutes;
    var modifiedDate = date.subtract(Duration(minutes: diffNow));
    modifiedDate =
        modifiedDate.subtract(Duration(minutes: modifiedDate.minute % 5));
    final _minutes = modifiedDate.minute - modifiedDate.minute % 5;
    final diffInMinutes = date.difference(now).inMinutes;
    log('painted: ${timeFormatter.format(modifiedDate)}');

    canvas
      ..drawLine(
        const Offset(0, 18),
        Offset(size.width, 18),
        Paint()
          ..color = Colors.white10
          ..strokeWidth = 3,
      )
      ..drawLine(
        const Offset(0, 18),
        const Offset(10, 18),
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 1,
      );

    if (diffInMinutes > 5) {
      final path = Path()
        ..moveTo(size.width / 2 - 10, size.height * 0.5 + 10)
        ..lineTo(size.width / 2, size.height * 0.5)
        ..lineTo(size.width / 2 + 10, size.height * 0.5 + 10);
      final paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawPath(path, paint);
    } else if (diffInMinutes > 0) {
      canvas.drawLine(
        const Offset(80, 18),
        Offset(size.width - 80, 18),
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 8,
      );
    } else {
      canvas.drawCircle(
        Offset(size.width / 2, size.height * 0.8),
        5,
        Paint()..color = Colors.black54,
      );
    }

    if (_minutes == 0) {
      if (date.hour == 0) {
        canvas.drawParagraph(
          (ParagraphBuilder(ParagraphStyle())
                ..pushStyle(captionTextStyle)
                ..addText(
                  timeFormatter.format(modifiedDate),
                ))
              .build()
            ..layout(const ParagraphConstraints(width: 100)),
          Offset(size.width / 2 - 30, 10),
        );
      }
      if (date.hour == 12) {
        canvas.drawLine(
          const Offset(50, 40),
          Offset(size.width - 20, 40),
          Paint()
            ..color = Colors.greenAccent
            ..strokeWidth = 5,
        );
      }
    }

    canvas.drawParagraph(
      (ParagraphBuilder(ParagraphStyle())
            ..pushStyle(captionTextStyle)
            ..addText(timeFormatter.format(modifiedDate)))
          .build()
        ..layout(const ParagraphConstraints(width: 100)),
      Offset(size.width - 40, 10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
