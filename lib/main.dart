import 'dart:developer';

import 'package:flutter/foundation.dart';
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
import 'package:islami/core/utils/app_colors.dart';
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
  _registerFontLicenses();
  // الخطوط متضمنة في assets/google_fonts بدل ما تتنزل من النت أول مرة
  // (كان أول تشغيل أو التشغيل من غير نت بيعرض خط تاني لحد ما الخط يوصل)
  GoogleFonts.config.allowRuntimeFetching = false;
  setUpServiceLocator();
  // كل التهيئات دي مستقلة عن بعض، فبتشتغل مع بعض بدل ما تستنى واحدة ورا التانية
  await Future.wait([
    // التصميم كله مبني على الوضع الطولي (designSize 395x825)
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    _openHiveBoxes(),
    // تهيئة مشغل الصوت للعمل في الخلفية وإظهار شريط الإشعارات
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.marwansaif.athar.channel.audio',
      androidNotificationChannelName: 'تشغيل الراديو والتلاوات',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
    ScreenUtil.ensureScreenSize(),
    Prefs.init(),
    NotificationHelper.init(),
  ]);
  runApp(const MainApp());
  _scheduleNotifications();
}

Future<void> _openHiveBoxes() async {
  await Hive.initFlutter();
  registerAdapters();
  await Future.wait([
    Hive.openBox<LocalSypha>('SyphaBox'),
    Hive.openBox<ZekrLocalDataMoel>(kZekrBox),
    Hive.openBox(ReadingTracker.boxName),
  ]);
}

void _registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final font in ['Amiri', 'Poppins']) {
      final license = await rootBundle.loadString(
        'assets/google_fonts/OFL-$font.txt',
      );
      yield LicenseEntryWithLineBreaks([font], license);
    }
    // مصادر البيانات بتظهر في صفحة "التراخيص ومصادر البيانات" في الإعدادات
    yield const LicenseEntryWithLineBreaks(
      ['Data sources'],
      '''
Quran text, Tafsir Al-Muyassar and the Saheeh International translation: the quran_with_tafsir package (pub.dev).
Ayah audio: everyayah.com.
Full recitations and live Quran radio: mp3quran.net.
Hadith texts and translations: fawazahmed0/hadith-api (github.com/fawazahmed0/hadith-api), served by jsDelivr.
Prayer times: the prayers_times package, calculated on the device.''',
    );
  });
}

/// بنعيد جدولة كل الإشعارات مع كل فتحة للأبلكيشن:
/// الأذان بيتجدول لأيام قدام بس، والأذكار بتتقرا من الإعدادات المتخزنة
Future<void> _scheduleNotifications() async {
  try {
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  final _settings = AppSettings.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _settings.locale.addListener(_rebuild);
    _settings.themeMode.addListener(_rebuild);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _settings.locale.removeListener(_rebuild);
    _settings.themeMode.removeListener(_rebuild);
    super.dispose();
  }

  // لما المستخدم يغير وضع الموبايل (فاتح/داكن) والتطبيق على "حسب الموبايل"
  @override
  void didChangePlatformBrightness() => _rebuild();

  void _rebuild() => setState(() {});

  Brightness get _brightness => switch (_settings.themeMode.value) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
  };

  @override
  Widget build(BuildContext context) {
    final brightness = _brightness;
    // لازم يتحدد قبل ما أي ويدجت تقرا AppColors
    AppColors.brightness = brightness;
    final locale = _settings.locale.value;
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(395, 825),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          final dark = brightness == Brightness.dark;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value:
                (dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
                    .copyWith(
                      statusBarColor: Colors.transparent,
                      systemNavigationBarColor: AppColors.backgroundDeep,
                    ),
            // حجم خط النظام بيتضرب في .sp، فبنحطله حد أقصى عشان الكروت متتكسرش
            child: MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: mediaQuery.textScaler.clamp(
                  minScaleFactor: 0.85,
                  maxScaleFactor: 1.3,
                ),
              ),
              // الألوان مش جاية من Theme.of، فمع تغيير الوضع بنبني الشاشات
              // من جديد (مكان المستخدم في التنقل محفوظ في الـ router)
              child: KeyedSubtree(key: ValueKey(brightness), child: child!),
            ),
          );
        },
        themeAnimationDuration: Duration.zero,
        theme: _buildTheme(brightness),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: locale,
        routerConfig: AppRouter.router,
      ),
    );
  }

  /// ثيم المكونات الجاهزة (الحوارات، المفاتيح، الشيتات، صفحة التراخيص...)
  /// بنفس ألوان AppColors للوضع الحالي
  static ThemeData _buildTheme(Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          brightness: brightness,
        ).copyWith(
          primary: AppColors.primaryColor,
          onPrimary: AppColors.onPrimary,
          secondary: AppColors.primaryColor,
          onSecondary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.text,
          error: AppColors.danger,
        );
    return base.copyWith(
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      canvasColor: AppColors.backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      iconTheme: IconThemeData(color: AppColors.primaryColor),
      dividerColor: AppColors.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: AppColors.text,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceHigh,
        titleTextStyle: TextStyle(
          color: AppColors.primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(color: AppColors.text, fontSize: 15),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceHigh,
        modalBackgroundColor: AppColors.surfaceHigh,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: TextStyle(color: AppColors.text),
        actionTextColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
      ),
    );
  }
}
