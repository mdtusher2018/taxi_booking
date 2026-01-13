// import 'package:flutter/material.dart';
//
// class CustomLoaderWidget extends StatelessWidget {
//   final double size;
//   final Color color;
//   final double strokeWidth;
//   final Widget? child;
//
//   const CustomLoaderWidget({
//     super.key,
//     this.size = 50.0,
//     this.color = Colors.blue,
//     this.strokeWidth = 4.0,
//     this.child,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: size,
//       height: size,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           CircularProgressIndicator(
//             valueColor: AlwaysStoppedAnimation<Color>(color),
//             strokeWidth: strokeWidth,
//           ),
//           if (child != null) child!,
//         ],
//       ),
//     );
//   }
// }
import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomLoaderWidget extends StatefulWidget {
  final double size;
  final List<Color> colors;
  final double strokeWidth;
  final Widget? child;
  final Duration duration;

  const CustomLoaderWidget({
    Key? key,
    this.size = 35.0,
    this.colors = const [Colors.blue, Colors.purple],
    this.strokeWidth = 5.0,
    this.child,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  State<CustomLoaderWidget> createState() => _CustomLoaderWidgetState();
}

class _CustomLoaderWidgetState extends State<CustomLoaderWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: CustomPaint(
                    size: Size(widget.size, widget.size),
                    painter: _GradientRingPainter(
                      colors: widget.colors,
                      strokeWidth: widget.strokeWidth,
                    ),
                  ),
                );
              },
            ),
            if (widget.child != null) widget.child!,
          ],
        ),
      ),
    );
  }
}

class _GradientRingPainter extends CustomPainter {
  final List<Color> colors;
  final double strokeWidth;

  _GradientRingPainter({required this.colors, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Paint ringPaint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final double radius = (size.width / 2) - strokeWidth / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw the arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      2 * math.pi,
      false,
      ringPaint,
    );

    // Draw rounded head (highlight) at 0 radians
    final double headX = center.dx + radius * math.cos(0);
    final double headY = center.dy + radius * math.sin(0);
    final Paint headPaint = Paint()
      ..color = colors.last
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(headX, headY),
      strokeWidth * 0.50,
      headPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GradientRingPainter oldDelegate) =>
      oldDelegate.colors != colors || oldDelegate.strokeWidth != strokeWidth;
}