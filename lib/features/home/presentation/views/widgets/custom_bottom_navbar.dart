import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/home/presentation/views/widgets/bottom_nav_item.dart';
import 'package:islami/generated/l10n.dart';

class CustomBottomNaBar extends StatefulWidget {
  const CustomBottomNaBar({super.key, required this.currentIndex});
  final void Function(int index) currentIndex;

  @override
  State<CustomBottomNaBar> createState() => _CustomBottomNaBarState();
}

class _CustomBottomNaBarState extends State<CustomBottomNaBar> {
  var currentIndex = 2;

  List<({NavIcon icon, String label})> get _items => [
    (
      icon: const NavIcon.material(Icons.radio_rounded),
      label: S.of(context).navRadio,
    ),
    (
      icon: const NavIcon.material(Icons.menu_book_rounded),
      label: S.of(context).navQuran,
    ),
    (
      icon: const NavIcon.material(Icons.mosque_rounded),
      label: S.of(context).navHome,
    ),
    (
      icon: NavIcon.custom(
        (color, size) => TasbihIcon(color: color, size: size),
      ),
      label: S.of(context).navTasbih,
    ),
    (
      icon: const NavIcon.material(Icons.explore_rounded),
      label: S.of(context).navQibla,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // شريط عائم من غير أجزاء طالعة فوقه، والمحتوى بيعدّي من تحته (extendBody)
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 12),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.22),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: AppColors.isDark ? 0.45 : 0.1,
              ),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // المختار بس اللي بيتمط/يتقلص (عشان الاسم)، والباقي 48 ثابتة
            for (int i = 0; i < _items.length; i++)
              Flexible(
                flex: currentIndex == i ? 1 : 0,
                child: BottomNavItem(
                  icon: _items[i].icon,
                  isSelected: currentIndex == i,
                  label: _items[i].label,
                  onTap: () {
                    currentIndex = i;
                    widget.currentIndex(i);
                    setState(() {});
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
