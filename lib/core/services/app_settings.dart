import 'package:flutter/material.dart';
import 'package:islami/core/services/shared_prefs.dart';

enum AdhanSound { full, short, tone, silent }

/// إعدادات التطبيق العامة (اللغة، صوت الأذان، القراءة) متخزنة في Prefs.
/// إعدادات المواقيت والأذان لكل صلاة في PrayerTimesService / PrayerNotifications
class AppSettings {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const String _languageKey = 'app_language';
  static const String _adhanSoundKey = 'adhan_sound';
  static const String _fontSizeKey = 'quran_font_size';
  static const String _translationKey = 'quran_show_translation';

  static const double minFontSize = 18;
  static const double maxFontSize = 34;

  late final ValueNotifier<Locale> locale =
      ValueNotifier(Locale(Prefs.getData(key: _languageKey) ?? 'ar'));

  /// بيزيد مع أي تغيير في إعدادات القراءة عشان شاشة السورة تتحدث
  final ValueNotifier<int> readingChanges = ValueNotifier(0);

  bool get isArabic => locale.value.languageCode == 'ar';

  Future<void> setLanguage(String code) async {
    await Prefs.saveData(key: _languageKey, value: code);
    locale.value = Locale(code);
  }

  AdhanSound get adhanSound => AdhanSound.values.firstWhere(
        (sound) => sound.name == Prefs.getData(key: _adhanSoundKey),
        orElse: () => AdhanSound.full,
      );

  Future<void> setAdhanSound(AdhanSound sound) =>
      Prefs.saveData(key: _adhanSoundKey, value: sound.name);

  double get quranFontSize =>
      (Prefs.getData(key: _fontSizeKey) as num?)?.toDouble() ?? 22;

  Future<void> setQuranFontSize(double size) async {
    await Prefs.saveData(key: _fontSizeKey, value: size);
    readingChanges.value++;
  }

  bool get showTranslation => Prefs.getData(key: _translationKey) ?? false;

  Future<void> setShowTranslation(bool show) async {
    await Prefs.saveData(key: _translationKey, value: show);
    readingChanges.value++;
  }
}
