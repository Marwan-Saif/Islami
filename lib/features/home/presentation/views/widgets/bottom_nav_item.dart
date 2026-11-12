import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';

/// أيقونة تاب: يا إما IconData من Material (رخصة Apache 2.0)
/// يا إما رسمة بالكود زي السبحة
class NavIcon {
  const NavIcon.material(IconData this.icon) : painter = null;
  const NavIcon.custom(Widget Function(Color color, double size) this.painter)
    : icon = null;

  final IconData? icon;
  final Widget Function(Color color, double size)? painter;

  Widget build(Color color, double size) => icon != null
      ? Icon(icon, color: color, size: size)
      : painter!(color, size);
}

/// تاب في الشريط العائم: المختار كبسولة دهبي فيها الأيقونة والاسم،
/// والباقي أيقونة بس (والاسم للقارئ الصوتي والـ tooltip)
class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final NavIcon icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  static const _duration = Duration(milliseconds: 240);

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.onPrimary : AppColors.textMuted;
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: Tooltip(
        message: isSelected ? '' : label,
        child: InkResponse(
          onTap: onTap,
          radius: 28,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(24),
          child: AnimatedContainer(
            duration: _duration,
            curve: Curves.easeOutCubic,
            height: 46,
            // مساحة اللمس 48 على الأقل حتى للتابات اللي أيقونة بس
            constraints: const BoxConstraints(minWidth: 48),
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 10),
            decoration: BoxDecoration(
              gradient: isSelected ? AppColors.goldGradient : null,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon.build(color, 24),
                // الاسم للمختار بس، وبيتقص لو الشاشة ضيقة (التاب المختار هو
                // الوحيد اللي عرضه محدود جوه Flexible في الشريط)
                if (isSelected)
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8),
                      child: Text(
                        label,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                          color: color,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// أيقونة السبحة: حبات على دايرة وشرّابة
class TasbihIcon extends StatelessWidget {
  const TasbihIcon({super.key, required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size.square(size), painter: _TasbihIconPainter(color));
}

class _TasbihIconPainter extends CustomPainter {
  _TasbihIconPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final s = size.width;
    final center = Offset(s / 2, s * 0.42);
    final radius = s * 0.3;
    const beads = 11;
    // الحبات على دايرة، والفتحة اللي تحت مكان الشرّابة
    for (int i = 0; i < beads; i++) {
      final angle =
          math.pi / 2 + (i + 0.5) * (2 * math.pi - 0.9) / beads + 0.45;
      canvas.drawCircle(
        center + Offset(math.cos(angle), math.sin(angle)) * radius,
        s * 0.065,
        paint,
      );
    }
    // الحبة الكبيرة والشرّابة
    final top = center + Offset(0, radius + s * 0.04);
    canvas.drawCircle(top, s * 0.085, paint);
    final tassel = Path()
      ..moveTo(top.dx, top.dy + s * 0.04)
      ..lineTo(top.dx + s * 0.1, s * 0.98)
      ..lineTo(top.dx - s * 0.1, s * 0.98)
      ..close();
    canvas.drawPath(tassel, paint);
  }

  @override
  bool shouldRepaint(_TasbihIconPainter old) => old.color != color;
}
