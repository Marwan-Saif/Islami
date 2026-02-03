import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';
// import 'package:planets/constants.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
  });
  final String icon;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: [
          CircleAvatar(
            
            radius: isSelected ? 25 : 22,
            backgroundColor:
                isSelected ? AppColors.backgroundColor : AppColors.primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                icon,
                fit: BoxFit.fill,
                color: isSelected
                    ? AppColors.primaryColor
                    : AppColors.backgroundColor,
              ),
            ), //SvgPicture.asset(icon,),
          ),
          const SizedBox(
            height: 5,
          ),
          isSelected
              ? Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? AppColors.primaryColor
                        : AppColors.primaryColor,
                    fontSize: 15,
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
