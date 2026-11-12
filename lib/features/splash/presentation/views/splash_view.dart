import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/brand_header.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';
import 'package:islami/generated/l10n.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // مفيش صور تتفك قبل الرئيسية دلوقتي (كل الرسومات بالكود)،
    // فالـ splash بيستنى الأنيميشن بس
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 1400));
      if (!mounted) return;
      // الـ onboarding أول مرة بس، وبعد كده على الرئيسية على طول
      final seen = Prefs.getData(key: kOnboardingSeenKey) == true;
      context.go(seen ? AppRouter.homeView : AppRouter.onBoardingView);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashBody();
  }
}

class SplashBody extends StatelessWidget {
  const SplashBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatternBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 3),
              // اللوجو بيظهر بتكبير ونور خفيف
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.85, end: 1),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutBack,
                builder: (context, scale, child) => Opacity(
                  opacity: ((scale - 0.85) / 0.15).clamp(0, 1),
                  child: Transform.scale(scale: scale, child: child),
                ),
                child: const Column(
                  children: [
                    AtharLogo(size: 170),
                    SizedBox(height: 8),
                    BrandName(fontSize: 44),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                S.of(context).appTagline,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 15),
              ),
              const Spacer(flex: 4),
              Text(
                'Marwan Saif',
                style: TextStyle(
                  color: AppColors.textFaint,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
