import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';

/// خلفية التطبيق: تدرج الثيم وفوقه زخرفة إسلامية هندسية خفيفة.
/// بدل صور الخلفيات (كانت ~1.5 ميجا وعليها حقوق)، ومرسومة مرة واحدة
/// جوه RepaintBoundary فمش بتتعاد مع الـ scroll.
class PatternBackground extends StatelessWidget {
  const PatternBackground({super.key, this.child, this.opacity = 1});

  final Widget? child;

  /// شدة الزخرفة (1 = الافتراضي)
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          IslamicPatternLayer(opacity: opacity),
          ?child,
        ],
      ),
    );
  }
}

/// الزخرفة لوحدها (من غير التدرج) عشان تتحط فوق أي لون
class IslamicPatternLayer extends StatelessWidget {
  const IslamicPatternLayer({super.key, this.opacity = 1, this.color});

  final double opacity;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final base = color ?? AppColors.primaryColor;
    return IgnorePointer(
      child: RepaintBoundary(
        child: CustomPaint(
          isComplex: true,
          painter: IslamicPatternPainter(
            color: base.withValues(
              alpha: (AppColors.isDark ? 0.07 : 0.09) * opacity,
            ),
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

/// شبكة نجوم ثمانية متصلة بخطوط (نقشة "خاتم سليمان" المعروفة في الزخرفة الإسلامية)
class IslamicPatternPainter extends CustomPainter {
  IslamicPatternPainter({required this.color, this.cell = 56});

  final Color color;
  final double cell;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final r = cell * 0.36;
    final cols = (size.width / cell).ceil() + 1;
    final rows = (size.height / cell).ceil() + 1;
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final center = Offset(col * cell, row * cell);
        canvas.drawPath(octagramPath(center, r), paint);
        // معين صغير في النص بين كل أربع نجوم
        final mid = center + Offset(cell / 2, cell / 2);
        final d = cell * 0.14;
        canvas.drawPath(
          Path()
            ..moveTo(mid.dx, mid.dy - d)
            ..lineTo(mid.dx + d, mid.dy)
            ..lineTo(mid.dx, mid.dy + d)
            ..lineTo(mid.dx - d, mid.dy)
            ..close(),
          paint,
        );
        // خطوط بتوصل رؤوس النجوم ببعض
        final edge = r * math.cos(math.pi / 8);
        canvas.drawLine(
          center + Offset(edge, 0),
          center + Offset(cell - edge, 0),
          paint,
        );
        canvas.drawLine(
          center + Offset(0, edge),
          center + Offset(0, cell - edge),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(IslamicPatternPainter old) =>
      old.color != color || old.cell != cell;
}
