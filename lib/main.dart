import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:islami/constants.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/services/local_scheduled_notification.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';
import 'package:islami/features/Timer/data/hive/zekr_localdata.dart';
import 'package:islami/generated/l10n.dart';

import 'package:islami/hive_helper/register_adapters.dart';

void main() async { 
  WidgetsFlutterBinding.ensureInitialized();
  setUpServiceLocator();
  await Hive.initFlutter();
  registerAdapters();
  await Hive.openBox<LocalSypha>('SyphaBox');
  await Hive.openBox<ZekrLocalDataMoel>(kZekrBox);
  await ScreenUtil.ensureScreenSize();
  NotificationHelper.init();
  NotificationHelper.cancelAllNotifications();
  await Prefs.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    log("${MediaQuery.of(context).size.height}  ${MediaQuery.of(context).size.width} ${MediaQuery.of(context).devicePixelRatio}");
    return ScreenUtilInit(
      minTextAdapt: true,
      designSize: const Size(395, 825),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale('ar'),
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
