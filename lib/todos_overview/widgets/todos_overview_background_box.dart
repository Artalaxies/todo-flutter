import 'package:flutter/material.dart';

class TodosOverviewBackgroundBox extends StatelessWidget {
  const TodosOverviewBackgroundBox({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
        color: const Color(0xAAE3D6A9),
        child: CustomPaint(
            painter: const BackgroundCustomPainter(), child: child));
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
      canvas
        ..drawLine(
          Offset(0, size.height / 2 - (content.length - index) * 10),
          Offset(
            50 - value * 15,
            size.height / 2 - (content.length - index) * 10,
          ),
          paint,
        )
        ..drawLine(
          Offset(
            size.width - (50 - value * 15),
            size.height / 2 - (content.length - index) * 10,
          ),
          Offset(size.width, size.height / 2 - (content.length - index) * 10),
          paint,
        );
    });
  }
}
