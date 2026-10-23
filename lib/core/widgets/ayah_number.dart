import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';

/// رقم الآية جوه نجمة ثمانية مرسومة بالكود
class AyahNumber extends StatelessWidget {
  const AyahNumber({super.key, required this.number, this.size, this.volum});
  final int number;
  final double? size;
  final double? volum;

  @override
  Widget build(BuildContext context) {
    final side = 40.w;
    return SizedBox.square(
      dimension: side,
      child: CustomPaint(
        painter: _OctagramPainter(AppColors.primaryColor),
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(
              color: AppColors.text,
              fontSize: (number > 99 ? 11 : 13).sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _OctagramPainter extends CustomPainter {
  _OctagramPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 1;
    canvas.drawPath(
      octagramPath(center, radius),
      Paint()
        ..color = color.withValues(alpha: 0.12)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      octagramPath(center, radius),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  @override
  bool shouldRepaint(_OctagramPainter old) => old.color != color;
}
