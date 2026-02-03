import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/generated/l10n.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      curve:Curves.elasticIn ,
        skipOrBackFlex: 3,
        nextFlex: 3,
        dotsFlex: 5,
        dotsDecorator: DotsDecorator(
          size: const Size.square(8.0),
          activeSize: const Size(25.0, 9.0),
          activeColor: AppColors.primaryColor,
          color: Colors.grey,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
        globalBackgroundColor: AppColors.backgroundColor,
        isProgressTap: true,
        showNextButton: true,
        next: Text(
          S.of(context).next,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              fontSize: 16),
        ),
        showSkipButton: true,
        skipSemantic: 'Skip',
        // onSkip: () {
          
        // },
        // skipStyle: ,
        skip: Text(
          S.of(context).skip,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              fontSize: 16),
        ),
        // back: Text(
        //   S.of(context).back,
        //   style: const TextStyle(
        //       fontWeight: FontWeight.w500,
        //       color: AppColors.primaryColor,
        //       fontSize: 16),
        // ),
        // showBackButton: true,
        done: Text(
          S.of(context).finish,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
              fontSize: 16),
        ),
        onDone: () {
          context.go(AppRouter.homeView);
          // On button pressed
        },
        pages: [
          customPageViewModel(
              title: S.of(context).onboarding1_title,
              image: Assets.imagesKabba,
              child: S.of(context).onboarding1_body),
          customPageViewModel(
              title: S.of(context).onboarding2_title,
              image: Assets.imagesWelcome,
              child: S.of(context).onboarding2_body),
          customPageViewModel(
              title: S.of(context).onboarding3_title,
              image: Assets.imagesBearish,
              child: S.of(context).onboarding3_body),
          customPageViewModel(
              title: S.of(context).onboarding4_title,
              image: Assets.imagesRadio,
              child: S.of(context).onboarding4_body),
        ]);
  }

  PageViewModel customPageViewModel(
      {required String title, required String image, required String child}) {
    return PageViewModel(
      titleWidget: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          decoration: TextDecoration.none,
        ),
      ),
      bodyWidget: Text(
        textAlign: TextAlign.center,
        child,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.primaryColor,
          decoration: TextDecoration.none,
        ),
      ),
      decoration: const PageDecoration(
          imageFlex: 3, pageColor: AppColors.backgroundColor),
      image: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
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
          Image.asset(
            image,
            width: 270,
            height: 300,
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }
}
