import 'package:flutter/material.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Qibla/presentation/views/qibla_view.dart';
import 'package:islami/features/Quran/presentation/views/quran_view.dart';
import 'package:islami/features/Radio/presentation/views/radio_view.dart';
import 'package:islami/features/Sebha/presentation/views/sebha_view.dart';
import 'package:islami/features/Timer/presentation/views/timer_view.dart';
import 'package:islami/features/home/presentation/views/widgets/custom_bottom_navbar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultScreen();
  }
}

class DefaultScreen extends StatefulWidget {
  const DefaultScreen({
    super.key,
  });

  @override
  State<DefaultScreen> createState() => _DefaultScreenState();
}

class _DefaultScreenState extends State<DefaultScreen> {
  int currentIndex = 2;
  // الرئيسية بس بتتبني مع فتح الأبلكيشن (بدل الخمس تابات مرة واحدة)،
  // وباقي التابات بتتبني في الخلفية بعدها، وبعد كده بتفضل محفوظة في الـ IndexedStack
  final Set<int> _builtTabs = {2};

  @override
  void initState() {
    super.initState();
    // إذن الإشعارات بيتطلب لما الرئيسية تظهر، مش فوق الـ splash أو الـ onboarding
    NotificationHelper.requestPermissions();
    _prebuildTabs();
  }

  // تاب واحد كل frame بعد ما الرئيسية تستقر، عشان أول فتحة لأي تاب متهنجش
  Future<void> _prebuildTabs() async {
    await Future.delayed(const Duration(seconds: 2));
    for (final index in const [1, 0, 3, 4]) {
      if (!mounted) return;
      if (_builtTabs.add(index)) setState(() {});
      await WidgetsBinding.instance.endOfFrame;
    }
  }

  static Widget _tab(int index) => switch (index) {
        0 => const RadioView(),
        1 => const QuranView(),
        2 => const TimerView(),
        3 => const SebhaView(),
        _ => const QiblaScreen(),
      };

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //background
        Image.asset(
          Assets.imagesTajMahalAgraIndia,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        //scaffold
        Positioned(
          child: Scaffold(
            backgroundColor: AppColors.backgroundColor.withAlpha(150),
            body: IndexedStack(
              index: currentIndex,
              children: [
                for (int i = 0; i < 5; i++)
                  _builtTabs.contains(i) ? _tab(i) : const SizedBox.shrink(),
              ],
            ),
            bottomNavigationBar: CustomBottomNaBar(
              currentIndex: (index) {
                currentIndex = index;
                _builtTabs.add(index);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }
}
