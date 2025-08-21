import 'dart:math' as math;
import 'package:flutter/material.dart';

class InfographicLoop extends StatefulWidget {
  final double size;
  final Color color;
  final int bars;
  final Duration duration;

  const InfographicLoop({
    super.key,
    this.size = 40,
    required this.color,
    this.bars = 4,
    this.duration = const Duration(milliseconds: 1400),
  });

  @override
  State<InfographicLoop> createState() => _InfographicLoopState();
}

class _InfographicLoopState extends State<InfographicLoop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _BarsPainter(
              progress: _controller.value,
              color: widget.color,
              bars: widget.bars.clamp(3, 8),
            ),
          );
        },
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  final double progress;
  final Color color;
  final int bars;

  _BarsPainter({
    required this.progress,
    required this.color,
    required this.bars,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..isAntiAlias = true;
    final barWidth = size.width / (bars * 1.8);
    final gap = barWidth * 0.8;
    final radius = Radius.circular(barWidth);

    final totalWidth = bars * barWidth + (bars - 1) * gap;
    double x = (size.width - totalWidth) / 2;

    for (int i = 0; i < bars; i++) {
      final phaseShift = (i / bars) * math.pi * 2;
      final t = progress * math.pi * 2 + phaseShift;
      final hFactor = 0.35 + 0.6 * (0.5 * (math.sin(t) + 1));
      final barHeight = size.height * hFactor;
      final y = (size.height - barHeight) / 2;

      final rrect = RRect.fromRectAndCorners(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      );
      canvas.drawRRect(rrect, paint);

      x += barWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.bars != bars;
  }
}
