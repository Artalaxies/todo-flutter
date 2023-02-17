/*
 * Copyright (c) 2023, Artalaxies LLC - All Rights Reserved
 * Unauthorized copying or redistribution of this file in source and binary forms via any medium is strictly prohibited.
 */

import 'package:flutter/material.dart';

class InfiniteTimeViewBackgroundContainer extends StatelessWidget {
  const InfiniteTimeViewBackgroundContainer({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFE8E0C2),
      child: CustomPaint(
        painter: const BackgroundCustomPainter(),
        child: child,
      ),
    );
  }
}

class BackgroundCustomPainter extends CustomPainter {
  const BackgroundCustomPainter() : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black38
      ..strokeWidth = 1;
    _timePointingGraph(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

  void _timePointingGraph(Canvas canvas, Size size, Paint paint) {
    final content = Iterable.generate(
      10,
      (index) => (index - 5).abs(),
    ).toList();
    content.asMap().forEach((index, value) {
      final double leftLinePoint = 50 - value * 15;
      final double rightLinePoint = size.width - (50 - value * 15);


      canvas..drawLine(
        Offset(0, size.height / 2 - (content.length - index) * 10),
        Offset(
          leftLinePoint < 0 ? 0 : leftLinePoint,
          size.height / 2 - (content.length - index) * 10,
        ),
        paint,
      )..drawLine(
        Offset(
          rightLinePoint > size.width ? size.width : rightLinePoint,
            size.height / 2 - (content.length - index) * 10,
          ),
        Offset(size.width, size.height / 2 - (content.length - index) * 10),
        paint,
      );
    });
  }
}
