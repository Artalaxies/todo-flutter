/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:todos/app/widgets/avatar.dart';

class TodosOverviewAppbar extends StatelessWidget {
  const TodosOverviewAppbar(this.controller, {super.key});

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final paddingSize = MediaQuery.of(context).padding.top;

    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      toolbarHeight: 50,
      automaticallyImplyLeading: false,
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
      ),
      actions: [
        IconButton(
          color: Colors.black,
          onPressed: () {},
          icon: const Icon(Icons.search),
        ),
        Builder(
          builder: (context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
              // if(context.read<GeneralUserBloc>().state.user.isEmpty){
              //   context.go('/login');
              // }
            },
            icon: const Avatar(),
          ),
        ),
      ],
    );
  }
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
    // final paint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.fill
    //   ..strokeWidth = 5;
    // final paint2 = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 3;
    // final path = Path()
    //   ..moveTo(0, padding)
    //   ..lineTo(170, padding)
    //   ..lineTo(140, padding + height)
    //   ..lineTo(0, padding + height);
    // final path2 = Path()
    //   ..moveTo(size.width, padding)
    //   ..lineTo(size.width - 170, padding)
    //   ..lineTo(size.width - 140, padding + height)
    //   ..lineTo(size.width, padding + height);
    final style = ui.TextStyle(
        color: Colors.black, fontSize: 30, fontWeight: FontWeight.w800);

    canvas
        // ..drawPath(path, paint)
        // ..drawPath(path, paint2)
        // ..drawPath(path2, paint)
        // ..drawPath(path2, paint2)
        .drawParagraph(
      (ParagraphBuilder(ParagraphStyle(maxLines: 1))
            ..pushStyle(style)
            ..addText(
              'Today 0/0',
            ))
          .build()
        ..layout(const ParagraphConstraints(width: 500)),
      Offset(10, padding + 10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
