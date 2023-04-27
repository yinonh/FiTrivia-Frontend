import 'package:flutter/material.dart';

class NumberLineGraph extends StatelessWidget {
  final List<int> numbers;

  NumberLineGraph({required this.numbers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final lineColor = theme.colorScheme.secondary;
    final dotColor = theme.colorScheme.primary;

    return numbers.length > 0 ? CustomPaint(
      size: const Size(200, 50),
      painter: _NumberLineGraphPainter(numbers, lineColor, dotColor),
    ) : const Text("No Data");
  }
}

class _NumberLineGraphPainter extends CustomPainter {
  final List<int> numbers;
  final Color lineColor;
  final Color dotColor;

  _NumberLineGraphPainter(this.numbers, this.lineColor, this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double xSpacing = width / (numbers.length - 1);
    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final Paint dotPaint = Paint()..color = dotColor;
    if (numbers.length > 0 && numbers[0] != 0) numbers.insert(0, 0);
    Path path = Path();
    path.moveTo(0, height);

    for (int i = 0; i < numbers.length; i++) {
      double x = i * xSpacing;
      double y;
      switch (numbers[i]) {
        case 0:
          y = height;
          break;
        case 1:
          y = height / 2;
          break;
        case 2:
          y = 0;
          break;
        default:
          y = height;
      }
      path.lineTo(x, y);
    }

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < numbers.length; i++) {
      double x = i * xSpacing;
      double y;
      switch (numbers[i]) {
        case 0:
          y = height;
          break;
        case 1:
          y = height / 2;
          break;
        case 2:
          y = 0;
          break;
        default:
          y = height;
      }
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_NumberLineGraphPainter oldDelegate) {
    return oldDelegate.numbers != numbers;
  }
}
