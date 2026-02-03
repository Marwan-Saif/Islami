
import 'package:flutter/material.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/home/presentation/views/widgets/custom_bottom_navbar.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({
    super.key, required this.screen,
  });
final Widget screen ;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          Assets.imagesTajMahalAgraIndia,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Positioned(
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor.withAlpha(150),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsetsDirectional.symmetric(horizontal: 60),
                  child: Image.asset(
                    Assets.imagesMosque001,
                    width: 200,
                  ),
                ),
              screen
              ],
            ),
            bottomNavigationBar:  CustomBottomNaBar(currentIndex: (index) {
              
            },),
          ),
        ),
      ],
    );
  }
}