import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/brand_header.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';
import 'package:islami/generated/l10n.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return PatternBackground(
      child: IntroductionScreen(
        curve: Curves.easeOutCubic,
        skipOrBackFlex: 3,
        nextFlex: 3,
        dotsFlex: 5,
        dotsDecorator: DotsDecorator(
          size: const Size.square(8.0),
          activeSize: const Size(25.0, 9.0),
          activeColor: AppColors.primaryColor,
          color: AppColors.textFaint,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        globalBackgroundColor: Colors.transparent,
        isProgressTap: true,
        showNextButton: true,
        next: Text(
          S.of(context).next,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
        ),
        showSkipButton: true,
        skipSemantic: 'Skip',
        // skipStyle: ,
        skip: Text(
          S.of(context).skip,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
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
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.primaryColor,
            fontSize: 16,
          ),
        ),
        onDone: () => _finish(context),
        onSkip: () => _finish(context),
        pages: [
          customPageViewModel(
            title: S.of(context).onboarding1_title,
            visual: const _OnboardingVisual.logo(),
            child: S.of(context).onboarding1_body,
          ),
          customPageViewModel(
            title: S.of(context).onboarding2_title,
            visual: const _OnboardingVisual(Icons.menu_book_rounded),
            child: S.of(context).onboarding2_body,
          ),
          customPageViewModel(
            title: S.of(context).onboarding3_title,
            visual: const _OnboardingVisual(Icons.mosque_rounded),
            child: S.of(context).onboarding3_body,
          ),
          customPageViewModel(
            title: S.of(context).onboarding4_title,
            visual: const _OnboardingVisual(Icons.radio_rounded),
            child: S.of(context).onboarding4_body,
          ),
        ],
      ),
    );
  }

  // الـ onboarding بيظهر أول مرة بس
  Future<void> _finish(BuildContext context) async {
    await Prefs.saveData(key: kOnboardingSeenKey, value: true);
    if (context.mounted) context.go(AppRouter.homeView);
  }

  PageViewModel customPageViewModel({
    required String title,
    required Widget visual,
    required String child,
  }) {
    return PageViewModel(
      titleWidget: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryColor,
          decoration: TextDecoration.none,
        ),
      ),
      bodyWidget: Text(
        textAlign: TextAlign.center,
        child,
        style: TextStyle(
          fontSize: 18,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
          decoration: TextDecoration.none,
        ),
      ),
      decoration: const PageDecoration(
        imageFlex: 3,
        pageColor: Colors.transparent,
        bodyPadding: EdgeInsets.symmetric(horizontal: 28),
      ),
      // الرسمة بتتظبط على المساحة المتاحة فمش بتعمل overflow في الشاشات الصغيرة
      image: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Center(child: visual),
      ),
    );
  }
}

/// رسمة كل صفحة: اللوجو في الأولى، وأيقونة جوه دايرة دهبية في الباقي
class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual(this.icon) : logo = false;
  const _OnboardingVisual.logo() : icon = null, logo = true;

  final IconData? icon;
  final bool logo;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final side = constraints.biggest.shortestSide.clamp(120.0, 260.0);
        if (logo) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AtharLogo(size: side * 0.75),
              BrandName(fontSize: side * 0.2),
            ],
          );
        }
        return SizedBox.square(
          dimension: side,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipOval(
                child: SizedBox.square(
                  dimension: side,
                  child: const IslamicPatternLayer(opacity: 2),
                ),
              ),
              Container(
                width: side * 0.62,
                height: side * 0.62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.goldGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Icon(icon, size: side * 0.3, color: AppColors.onPrimary),
              ),
            ],
          ),
        );
      },
    );
  }
}
