import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/home/presentation/views/widgets/bottom_nav_item.dart';
// import 'package:planets/views/widgets/bottom_nav_item.dart';

class CustomBottomNaBar extends StatefulWidget {
   CustomBottomNaBar({
    super.key,
    required this.currentIndex,
  });
  void Function(int index) currentIndex;

  @override
  State<CustomBottomNaBar> createState() => _CustomBottomNaBarState();
}

class _CustomBottomNaBarState extends State<CustomBottomNaBar> {
  var currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Black Horizontal Container
        Container(
          margin: const EdgeInsetsDirectional.symmetric(
              horizontal: 20, vertical: 10),
          height: 56,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(30)),
        ),
        Positioned(
          left: 30,
          right: 30,
          top: -25,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // First Icon
              GestureDetector(
                onTap: () {
                  widget.currentIndex(0);
                  currentIndex = 0;
                  setState(() {});
                },
                child: BottomNavItem(
                  icon: Assets.imagesRadio,
                  isSelected: currentIndex == 0,
                  label: 'Radio',
                ),
              ),
              // Second Icon
              GestureDetector(
                onTap: () {
                  currentIndex = 1;widget.currentIndex(1);
                  setState(() {});
                },
                child: BottomNavItem(
                  icon: Assets.imagesQuranIcon,
                  isSelected: currentIndex == 1,
                  label: 'Quran',
                ),
              ),
              // Third Icon
              GestureDetector(
                onTap: () {
                  currentIndex = 2;
                  widget.currentIndex(2);
                  setState(() {});
                },
                child: BottomNavItem(
                  icon: Assets.imagesTime,
                  isSelected: currentIndex == 2,
                  label: 'Home',
                ),
              ),
              // fourth Icon
              GestureDetector(
                onTap: () {
                  currentIndex = 3;
                  widget.currentIndex(3);
                  setState(() {});
                },
                child: BottomNavItem(
                  icon: Assets.imagesTasbih,
                  isSelected: currentIndex == 3,
                  label: 'Tasbih',
                ),
              ),
              // fifth Icon
              GestureDetector(
                onTap: () {
                  currentIndex = 4;
                  widget.currentIndex(4);
                  setState(() {});
                },
                child: BottomNavItem(
                  icon: Assets.imagesCompass,
                  isSelected: currentIndex == 4,
                  label: 'Qiplah',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
