import 'package:flutter/material.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:islami/generated/l10n.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
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
  const DefaultScreen({super.key});

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
    _requestPermissions();
    _prebuildTabs();
  }

  static const String _exactAlarmAskedKey = 'exact_alarm_asked';

  Future<void> _requestPermissions() async {
    await NotificationHelper.requestPermissions();
    // بعد إذن الإشعارات، بنشرح مرة واحدة ليه محتاجين إذن المنبّهات
    // (والإعدادات فيها زرار للإذن لو المستخدم قال مش دلوقتي)
    if (!PrayerNotifications.isEnabled ||
        Prefs.getData(key: _exactAlarmAskedKey) == true ||
        await NotificationHelper.canScheduleExact() ||
        !mounted) {
      return;
    }
    await Prefs.saveData(key: _exactAlarmAskedKey, value: true);
    if (!mounted) return;
    final allow = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.primaryColor, width: 1.5),
        ),
        icon: Icon(Icons.alarm_on_rounded, color: AppColors.primaryColor),
        title: Text(
          S.of(context).exactAlarmTitle,
          style: TextStyle(color: AppColors.primaryColor),
        ),
        content: Text(
          S.of(context).exactAlarmMessage,
          style: TextStyle(color: AppColors.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              S.of(context).exactAlarmLater,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.backgroundColor,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(S.of(context).exactAlarmAllow),
          ),
        ],
      ),
    );
    if (allow == true && await NotificationHelper.requestExactAlarms()) {
      await NotificationHelper.rescheduleAfterExactAlarmGrant();
    }
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
    // الخلفية زخرفة مرسومة بالكود بدل الصورة الفوتوغرافية
    return PatternBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // المحتوى بيكمل تحت الشريط العائم، والتابات بتسيب مسافة قدّه
        // (Scaffold بيحطها في MediaQuery.padding.bottom)
        extendBody: true,
        // المحتوى مش بيدخل تحت شريط الساعة والإشارة وهو بيعمل scroll
        body: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: currentIndex,
            children: [
              for (int i = 0; i < 5; i++)
                _builtTabs.contains(i) ? _tab(i) : const SizedBox.shrink(),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNaBar(
          currentIndex: (index) {
            currentIndex = index;
            _builtTabs.add(index);
            setState(() {});
          },
        ),
      ),
    );
  }
}
