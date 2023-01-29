/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todos/todos_overview/todo_bloc/changed_todo.dart';
import 'package:todos/todos_overview/todo_bloc/todo_bloc.dart';
import 'package:todos_api/todos_api.dart';

class TodoListTile extends StatelessWidget {
  const TodoListTile({
    super.key,
    required Todo todo,
    this.onToggleCompleted,
    this.onDismissed,
    this.onTap,
  }) : _todo = todo;

  final Todo _todo;
  final ValueChanged<bool>? onToggleCompleted;
  final DismissDirectionCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<TodoBloc, TodoState>(
      builder: (context, state) {
        final changedTodo = state.changedList[_todo.id];
        final todo = changedTodo?.toTodo() ?? _todo;
        final textEditingController = TextEditingController.fromValue(
          TextEditingValue(text: todo.title),
        )..selection = TextSelection.collapsed(
            offset: changedTodo?.index ?? todo.title.length,
          );
        return Dismissible(
          key: Key('todoListTile_dismissible_${todo.id}'),
          onDismissed: onDismissed,
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            color: theme.colorScheme.error,
            child: const Icon(
              Icons.delete,
              color: Color(0xAAFFFFFF),
            ),
          ),
          child: CustomPaint(
            painter: DatetimeBackgroundCustomPainter(
              datetime: todo.date,
            ),
            child: Row(
              children: [
                Checkbox(
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  value: todo.isCompleted,
                  onChanged: (completed) {
                    if (completed == true) {
                      context.read<TodoBloc>().add(
                            TodoOnChanged(
                              ChangedTodo.fromTodo(todo).copyWith(
                                isCompleted: true,
                                date: DateTime.now(),
                              ),
                            ),
                          );
                    } else {
                      context.read<TodoBloc>().add(
                            TodoOnChanged(
                              ChangedTodo.fromTodo(todo)
                                  .copyWith(isCompleted: false),
                            ),
                          );
                    }
                  },
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: TextFormField(
                    controller: textEditingController,
                    key: const Key('editTodoView_title_textFormField'),
                    decoration: const InputDecoration.collapsed(
                      hintText: 'what to do?',
                    ),
                    textCapitalization: TextCapitalization.words,
                    readOnly: todo.isCompleted,
                    style: todo.isCompleted
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : const TextStyle(),
                    // maxLength: 50,
                    // inputFormatters: [
                    // LengthLimitingTextInputFormatter(50),
                    // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                    // ],
                    onChanged: (value) {
                      context.read<TodoBloc>().add(
                            TodoOnChanged(
                              ChangedTodo.fromTodo(todo).copyWith(
                                title: value,
                                index:
                                    textEditingController.selection.baseOffset,
                              ),
                            ),
                          );
                    },
                    onEditingComplete: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DatetimeBackgroundCustomPainter extends CustomPainter {
  DatetimeBackgroundCustomPainter({
    this.datetime,
    ui.TextStyle? textStyle,
  }) : super() {
    _textStyle = textStyle ?? ui.TextStyle(color: Colors.grey);
  }

  late final ui.TextStyle _textStyle;
  final DateTime? datetime;
  final DateFormat formatter = DateFormat('hh:mm:ss');

  @override
  void paint(Canvas canvas, Size size) {
    if (datetime != null) {
      canvas.drawParagraph(
        (ParagraphBuilder(ParagraphStyle(maxLines: 1))
              ..pushStyle(_textStyle)
              ..addText(
                formatter.format(datetime!),
              ))
            .build()
          ..layout(ParagraphConstraints(width: size.width)),
        Offset(size.width - 70, 10),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
