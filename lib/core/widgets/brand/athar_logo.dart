import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';

/// لوجو أثر: فانوس بشباك على شكل محراب وجواه هلال منوّر.
/// مرسوم بالكود بالكامل (مفيش صور)، فبيبان حاد في أي مقاس وبيتلون مع الثيم.
/// نفس الرسمة بتتصدّر لأيقونة التطبيق وصورة الـ splash (test/tool/render_brand_test.dart)
class AtharLogo extends StatelessWidget {
  const AtharLogo({super.key, this.size = 96, this.glow = true, this.mono});

  final double size;

  /// توهج خفيف ورا الفانوس
  final bool glow;

  /// لو اتحدد بيترسم بلون واحد (أيقونة الإشعارات)
  final Color? mono;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: AtharLogoPainter(
          frame: AppColors.goldGradient.colors,
          light: AppColors.glow,
          glow: glow,
          mono: mono,
        ),
      ),
    );
  }
}

class AtharLogoPainter extends CustomPainter {
  AtharLogoPainter({
    required this.frame,
    required this.light,
    this.glow = true,
    this.mono,
  });

  /// تدرج جسم الفانوس
  final List<Color> frame;

  /// لون النور اللي جوه
  final Color light;
  final bool glow;
  final Color? mono;

  @override
  void paint(Canvas canvas, Size size) {
    // الرسمة متصممة على مربع 100×100 وبتتكبر على المساحة
    final s = size.shortestSide / 100;
    canvas.save();
    canvas.translate((size.width - 100 * s) / 2, (size.height - 100 * s) / 2);
    canvas.scale(s);

    final rect = const Rect.fromLTWH(20, 0, 60, 100);
    final framePaint = Paint()
      ..isAntiAlias = true
      ..shader = mono == null
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: frame,
            ).createShader(rect)
          : null
      ..color = mono ?? frame.first;

    if (glow && mono == null) {
      canvas.drawCircle(
        const Offset(50, 56),
        44,
        Paint()
          ..shader =
              RadialGradient(
                colors: [
                  light.withValues(alpha: 0.35),
                  light.withValues(alpha: 0),
                ],
              ).createShader(
                Rect.fromCircle(center: const Offset(50, 56), radius: 44),
              ),
      );
    }

    // الحلقة اللي بيتعلق منها
    canvas.drawCircle(
      const Offset(50, 7),
      4.2,
      Paint()
        ..color = mono ?? frame.first
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.6,
    );
    canvas.drawRect(const Rect.fromLTWH(48.8, 11, 2.4, 4), framePaint);

    // القبة
    final dome = Path()
      ..moveTo(33, 30)
      ..cubicTo(33, 21, 42, 15.5, 50, 14.5)
      ..cubicTo(58, 15.5, 67, 21, 67, 30)
      ..close();
    canvas.drawPath(dome, framePaint);

    // الحزام اللي فوق
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(29, 29, 42, 6),
        const Radius.circular(2),
      ),
      framePaint,
    );

    // جسم الفانوس (مسدس بيوسع في النص)
    final body = Path()
      ..moveTo(32, 35)
      ..lineTo(68, 35)
      ..lineTo(75, 55)
      ..lineTo(68, 77)
      ..lineTo(32, 77)
      ..lineTo(25, 55)
      ..close();

    // الشباك على شكل محراب، بيتقص من الجسم عشان يبان النور
    final window = Path()
      ..moveTo(39.5, 72)
      ..lineTo(39.5, 54)
      ..cubicTo(39.5, 46, 46, 41.5, 50, 40)
      ..cubicTo(54, 41.5, 60.5, 46, 60.5, 54)
      ..lineTo(60.5, 72)
      ..close();

    canvas.drawPath(
      Path.combine(PathOperation.difference, body, window),
      framePaint,
    );

    // النور جوه الشباك
    if (mono == null) {
      canvas.drawPath(
        window,
        Paint()
          ..shader = RadialGradient(
            center: const Alignment(0, 0.15),
            radius: 0.9,
            colors: [
              Colors.white.withValues(alpha: 0.95),
              light,
              light.withValues(alpha: 0.55),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(window.getBounds()),
      );
    }

    // الهلال جوه النور (في النسخة الأحادية بيتقص من الشباك نفسه)
    final crescent = Path.combine(
      PathOperation.difference,
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(50, 59), radius: 7.2)),
      Path()..addOval(
        Rect.fromCircle(center: const Offset(53.6, 56.6), radius: 6.2),
      ),
    );
    canvas.drawPath(crescent, Paint()..color = mono ?? frame.last);

    // خطوط الشباك الجانبية
    final rib = Paint()
      ..color = (mono ?? light).withValues(alpha: mono == null ? 0.55 : 1)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(30, 46), const Offset(35, 46), rib);
    canvas.drawLine(const Offset(65, 46), const Offset(70, 46), rib);
    canvas.drawLine(const Offset(30, 66), const Offset(35, 66), rib);
    canvas.drawLine(const Offset(65, 66), const Offset(70, 66), rib);

    // القاعدة
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(30, 77, 40, 6),
        const Radius.circular(2),
      ),
      framePaint,
    );
    final tip = Path()
      ..moveTo(38, 83)
      ..lineTo(62, 83)
      ..quadraticBezierTo(56, 88, 50, 94)
      ..quadraticBezierTo(44, 88, 38, 83)
      ..close();
    canvas.drawPath(tip, framePaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(AtharLogoPainter old) =>
      old.mono != mono || old.light != light || old.glow != glow;
}

/// نجمة ثمانية (خاتم) لرقم الآية وزخارف صغيرة
Path octagramPath(Offset center, double radius) {
  Path square(double rotation) {
    final path = Path();
    for (int i = 0; i < 4; i++) {
      final angle = rotation + i * math.pi / 2;
      final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  return Path.combine(PathOperation.union, square(math.pi / 4), square(0));
}
