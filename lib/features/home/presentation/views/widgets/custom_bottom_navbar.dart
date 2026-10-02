import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/home/presentation/views/widgets/bottom_nav_item.dart';

class CustomBottomNaBar extends StatefulWidget {
  const CustomBottomNaBar({
    super.key,
    required this.currentIndex,
  });
  final void Function(int index) currentIndex;

  @override
  State<CustomBottomNaBar> createState() => _CustomBottomNaBarState();
}

class _CustomBottomNaBarState extends State<CustomBottomNaBar> {
  var currentIndex = 2;

  static const List<({String icon, String label})> _items = [
    (icon: Assets.imagesRadio, label: 'Radio'),
    (icon: Assets.imagesQuranIcon, label: 'Quran'),
    (icon: Assets.imagesTime, label: 'Home'),
    (icon: Assets.imagesTasbih, label: 'Tasbih'),
    (icon: Assets.imagesCompass, label: 'Qiblah'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Black Horizontal Container
        Container(
          margin: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10),
          height: 56,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(30)),
        ),
        Positioned(
          left: 30.w,
          right: 30.w,
          top: -25,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Flexible lets the items shrink on narrow screens instead of overflowing
              for (int i = 0; i < _items.length; i++)
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      currentIndex = i;
                      widget.currentIndex(i);
                      setState(() {});
                    },
                    child: BottomNavItem(
                      icon: _items[i].icon,
                      isSelected: currentIndex == i,
                      label: _items[i].label,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
