// بيرسم كل صور الهوية (أيقونة التطبيق، صور الـ splash، أيقونة الإشعار،
// وصور المتجر) من نفس كود اللوجو والزخرفة اللي جوه التطبيق.
//
// التشغيل:  flutter test tool/render_brand_test.dart
// وبعده:    dart run flutter_launcher_icons && dart run flutter_native_splash:create
//
// مش جوه test/ عشان ميشتغلش مع flutter test العادي ويكتب ملفات كل مرة.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/core/widgets/brand/athar_logo.dart';
import 'package:islami/features/Qibla/presentation/views/qibla_view.dart';

const _navy = Color(0xFF0D1720);

Future<void> _loadFont(String family, String path) async {
  final loader = FontLoader(family)..addFont(rootBundle.load(path));
  await loader.load();
}

Future<void> _render(
  WidgetTester tester,
  String path,
  Size size,
  Widget child,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.rtl,
      child: RepaintBoundary(
        key: key,
        child: SizedBox.fromSize(size: size, child: child),
      ),
    ),
  );
  await tester.pump();
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    final file = File(path)..createSync(recursive: true);
    await file.writeAsBytes(bytes!.buffer.asUint8List());
  });
}

Widget _logo(double size, {Color? mono, bool glow = true}) => Center(
  child: CustomPaint(
    size: Size.square(size),
    painter: AtharLogoPainter(
      frame: AppColors.goldGradient.colors,
      light: AppColors.glow,
      glow: glow,
      mono: mono,
    ),
  ),
);

void main() {
  AppColors.brightness = Brightness.dark;

  testWidgets('render brand assets', (tester) async {
    await tester.runAsync(() async {
      await _loadFont('Amiri', 'assets/google_fonts/Amiri-Bold.ttf');
      await _loadFont('Poppins', 'assets/google_fonts/Poppins-Medium.ttf');
    });

    // أيقونة التطبيق (iOS وأندرويد القديم): فانوس على كحلي بزخرفة خفيفة
    await _render(
      tester,
      'assets/images/app_icon.png',
      const Size(1024, 1024),
      Container(
        color: _navy,
        child: Stack(
          children: [
            const Positioned.fill(child: IslamicPatternLayer(opacity: 1.2)),
            _logo(760),
          ],
        ),
      ),
    );

    // الطبقة الأمامية للأيقونة المتكيفة: لازم الرسمة جوه الـ 66% اللي في النص
    await _render(
      tester,
      'assets/brand/icon_foreground.png',
      const Size(1024, 1024),
      _logo(660),
    );

    // صورة الـ splash الأصلية وأندرويد 12
    await _render(
      tester,
      'assets/splash/splash_logo.png',
      const Size(480, 480),
      _logo(440),
    );
    await _render(
      tester,
      'assets/splash/splash_icon_android12.png',
      const Size(1152, 1152),
      _logo(700),
    );

    // أيقونة الإشعار: أبيض بس على شفاف (أندرويد بيلونها)
    const densities = {
      'mdpi': 24.0,
      'hdpi': 36.0,
      'xhdpi': 48.0,
      'xxhdpi': 72.0,
      'xxxhdpi': 96.0,
    };
    for (final entry in densities.entries) {
      await _render(
        tester,
        'android/app/src/main/res/drawable-${entry.key}/ic_notification.png',
        Size.square(entry.value),
        _logo(entry.value, mono: Colors.white, glow: false),
      );
    }

    // صور المتجر: الأيقونة 512 وصورة الغلاف 1024×500
    await _render(
      tester,
      'store/icon_512.png',
      const Size(512, 512),
      Container(
        color: _navy,
        child: Stack(
          children: [
            const Positioned.fill(child: IslamicPatternLayer(opacity: 1.2)),
            _logo(380),
          ],
        ),
      ),
    );
    await _render(
      tester,
      'store/feature_graphic.png',
      const Size(1024, 500),
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF13212D), _navy],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: IslamicPatternLayer(opacity: 1.4)),
            Row(
              children: [
                const SizedBox(width: 80),
                SizedBox(width: 300, child: _logo(300)),
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'أثر',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 150,
                          height: 1.1,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        'القرآن والصلاة والأذكار',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 44,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Athar  ·  Quran, prayer and azkar',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // معاينة لإبرة القبلة (مش بتتشحن مع التطبيق)
    await _render(
      tester,
      'build/brand_preview/qibla_needle.png',
      const Size(400, 400),
      Container(
        color: _navy,
        child: CustomPaint(
          painter: QiblaNeedlePainter(
            gold: AppColors.goldGradient.colors,
            kaaba: const Color(0xFF05080B),
            tail: AppColors.textFaint,
          ),
        ),
      ),
    );
  });
}
