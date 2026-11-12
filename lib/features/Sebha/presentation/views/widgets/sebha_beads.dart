import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';

/// سبحة من 33 حبة مرسومة بالكود. مع كل تسبيحة الحبات بتلف حبة واحدة،
/// والحبة اللي عند الشرّابة بتنور، زي ما الصباع بيعدّي الحبة في السبحة الحقيقية.
class SebhaBeads extends StatelessWidget {
  const SebhaBeads({super.key, required this.count, required this.child});

  final int count;
  final Widget child;

  static const int beads = 33;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: count.toDouble()),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => CustomPaint(
        painter: _BeadsPainter(
          progress: value,
          bead: AppColors.goldGradient.colors,
          highlight: AppColors.glow,
          string: AppColors.primaryColor.withValues(alpha: 0.35),
        ),
        child: child,
      ),
      child: child,
    );
  }
}

class _BeadsPainter extends CustomPainter {
  _BeadsPainter({
    required this.progress,
    required this.bead,
    required this.highlight,
    required this.string,
  });

  final double progress;
  final List<Color> bead;
  final Color highlight;
  final Color string;

  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    // الدايرة نازلة شوية عشان الشرّابة اللي فوق
    final center = Offset(size.width / 2, size.height / 2 + side * 0.06);
    final radius = side * 0.38;
    final beadRadius = radius * 0.085;
    const n = SebhaBeads.beads;
    final step = 2 * math.pi / n;

    // الخيط
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = string
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // الشرّابة والحبة الكبيرة (الإمام) فوق
    final top = center - Offset(0, radius);
    final tassel = Path()
      ..moveTo(top.dx, top.dy - beadRadius * 1.6)
      ..lineTo(top.dx + beadRadius * 1.4, top.dy - radius * 0.42)
      ..lineTo(top.dx - beadRadius * 1.4, top.dy - radius * 0.42)
      ..close();
    final goldPaint = Paint()
      ..shader = LinearGradient(
        colors: bead,
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.3));
    canvas.drawPath(tassel, goldPaint);
    canvas.drawCircle(
      top - Offset(0, beadRadius * 1.9),
      beadRadius * 1.35,
      goldPaint,
    );

    // الحبات. الحبة رقم 0 عند الإمام، وكل تسبيحة بتلف خطوة
    final rotation = -(progress % n) * step;
    for (int i = 1; i < n; i++) {
      final angle = -math.pi / 2 + i * step + rotation;
      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * radius;
      // الحبة اللي جنب الإمام من الناحيتين بتنور شوية
      final distance = ((angle + math.pi / 2) % (2 * math.pi));
      final near = math.min(distance, 2 * math.pi - distance) < step * 1.2;
      final rect = Rect.fromCircle(center: position, radius: beadRadius);
      canvas.drawCircle(
        position,
        beadRadius,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.35),
            colors: near ? [Colors.white, highlight] : [highlight, bead.last],
          ).createShader(rect),
      );
    }
  }

  @override
  bool shouldRepaint(_BeadsPainter old) =>
      old.progress != progress || old.highlight != highlight;
}
