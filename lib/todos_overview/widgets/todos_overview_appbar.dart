import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todos/app/todo_bloc/todo_bloc.dart';
import 'package:todos/app/user_bloc/general_user_bloc.dart';
import 'package:todos/app/widgets/avatar.dart';
import 'package:todos/todos_overview/bloc/todos_overview_bloc.dart';

AppBar todosOverviewAppbar(BuildContext context, ScrollController controller) {
  final paddingSize = MediaQuery.of(context).padding.top;

  return AppBar(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    foregroundColor: Colors.transparent,
    centerTitle: true,
    title: IconButton(
      color: Colors.black,
      onPressed: () {
        controller.animateTo(
          0,
          duration: Duration(
            milliseconds: controller.offset.abs().toInt(),
          ),
          curve: Curves.easeInOutQuart,
        );
      },
      icon: const Icon(Icons.arrow_upward),
    ),
    flexibleSpace: CustomPaint(
      painter: AppbarPainter(padding: paddingSize),
      // child: Text(
      //   'Today ${todayTodos.where((element) => element.isCompleted).length}/${todayTodos.length}',
      //   style: theme.textTheme.caption
      //       ?.copyWith(fontSize: 30, fontWeight: FontWeight.w800),
      // ),
    ),
    actions: [
      IconButton(
        color: Colors.black,
        onPressed: () {
          context.read<TodoBloc>().add(TodoSyncRequest());
        },
        icon: const Icon(Icons.refresh),
      ),
      IconButton(
        color: Colors.black,
        onPressed: () {},
        icon: const Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {
          if(context.read<GeneralUserBloc>().state.user.isEmpty){
            context.go('/login');
          }
        },
        icon: const Avatar(),
      )
    ],
  );
}

class AppbarPainter extends CustomPainter {
  AppbarPainter({
    required this.padding,
    ui.TextStyle? textStyle,
  }) {
    _textStyle = textStyle ?? ui.TextStyle(color: Colors.black);
  }

  late final ui.TextStyle _textStyle;
  final double padding;

  @override
  void paint(Canvas canvas, Size size) {
    const height = 50;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 5;
    final paint2 = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final path = Path()
      ..moveTo(0, padding)
      ..lineTo(170, padding)
      ..lineTo(140, padding + height)
      ..lineTo(0, padding + height);
    final path2 = Path()
      ..moveTo(size.width, padding)
      ..lineTo(size.width - 170, padding)
      ..lineTo(size.width - 140, padding + height)
      ..lineTo(size.width, padding + height);
    final style = ui.TextStyle(
        color: Colors.black, fontSize: 30, fontWeight: FontWeight.w800);

    canvas
      ..drawPath(path, paint)
      ..drawPath(path, paint2)
      ..drawPath(path2, paint)
      ..drawPath(path2, paint2)
      ..drawParagraph(
        (ParagraphBuilder(ParagraphStyle(maxLines: 1))
              ..pushStyle(style)
              ..addText(
                'Today 0/0',
              ))
            .build()
          ..layout(ParagraphConstraints(width: size.width)),
        Offset(5, padding + 5),
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
