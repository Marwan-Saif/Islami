import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';
import 'package:islami/features/Timer/data/azkar_notifications.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:islami/generated/l10n.dart';

import 'package:islami/hive_helper/register_adapters.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // التصميم كله مبني على الوضع الطولي (designSize 395x825)
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  setUpServiceLocator();
  await Hive.initFlutter();
  registerAdapters();
  // تهيئة مشغل الصوت للعمل في الخلفية وإظهار شريط الإشعارات
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.marwansaif.islami.channel.audio',
    androidNotificationChannelName: 'تشغيل الراديو والتلاوات',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: true,
  );
  //  JustAudioBackground.init();
  await Hive.openBox<LocalSypha>('SyphaBox');
  await Hive.openBox<ZekrLocalDataMoel>(kZekrBox);
  await Hive.openBox(ReadingTracker.boxName);
  await ScreenUtil.ensureScreenSize();
  await Prefs.init();
  await NotificationHelper.init();
  runApp(const MainApp());
  _scheduleNotifications();
}

/// بنعيد جدولة كل الإشعارات مع كل فتحة للأبلكيشن:
/// الأذان بيتجدول لأيام قدام بس، والأذكار بتتقرا من الإعدادات المتخزنة
Future<void> _scheduleNotifications() async {
  try {
    await NotificationHelper.requestPermissions();
    // بيشيل أي إشعارات قديمة بالـ IDs والـ channel القديمة قبل الجدولة
    await NotificationHelper.cancelAllNotifications();
    await AzkarNotifications.scheduleFromStorage();
    // لو إذن الموقع متاح (مثلاً من شاشة القبلة) المواقيت بتتحسب من مكان المستخدم
    await PrayerTimesService.updateLocation();
    await PrayerNotifications.scheduleUpcoming();
  } catch (e) {
    log('failed to schedule notifications: $e');
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    log(
      "${MediaQuery.of(context).size.height}  ${MediaQuery.of(context).size.width} ${MediaQuery.of(context).devicePixelRatio}",
    );
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(395, 825),
      // تغيير اللغة من الإعدادات بيعيد بناء التطبيق كله بالـ locale الجديدة
      child: ValueListenableBuilder<Locale>(
        valueListenable: AppSettings.instance.locale,
        builder: (context, locale, _) => MaterialApp.router(
          debugShowCheckedModeBanner: false,
          // حجم خط النظام بيتضرب في .sp، فبنحطله حد أقصى عشان الكروت متتكسرش
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: mediaQuery.textScaler.clamp(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.3,
                ),
              ),
              child: child!,
            );
          },
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: locale,
          theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
