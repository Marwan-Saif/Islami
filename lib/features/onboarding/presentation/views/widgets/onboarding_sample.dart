
import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';

class OnBoardingSample extends StatelessWidget {
  const OnBoardingSample({
    super.key,
    required this.image,
    required this.title,
    required this.child,
  });
  final String image, title;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.asset(
              Assets.imagesMosque01,
              width: 270,
            ),
            Positioned(
              bottom: 20,
              child: Image.asset(
                Assets.imagesIslami1,
                width: 270,
              ),
            ),
          ],
        ),
        Image.asset(image),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
            decoration: TextDecoration.none,
          ),
        ),
        child
      ],
    );
  }
}
