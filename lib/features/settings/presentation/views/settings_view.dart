import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/appbar.dart';
import 'package:islami/features/Timer/data/azkar_notifications.dart';
import 'package:islami/features/Quran/data/ayah_reciters.dart';
import 'package:islami/features/Quran/presentation/views/widgets/ayah_actions_sheet.dart';
import 'package:islami/features/Timer/data/prayer_settings_data.dart';
import 'package:islami/features/Timer/data/prayer_times_service.dart';
import 'package:islami/features/settings/presentation/views/widgets/about_section.dart';
import 'package:islami/features/settings/presentation/views/widgets/settings_widgets.dart';
import 'package:islami/generated/l10n.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _settings = AppSettings.instance;
  // معاينة الأصوات بـ audioplayers لأن just_audio_background بيسمح بمشغل واحد بس
  final AudioPlayer _preview = AudioPlayer();
  AdhanSound? _previewing;

  static const Map<AdhanSound, String> _soundAssets = {
    AdhanSound.full: 'sound/azan.mp3',
    AdhanSound.short: 'sound/azan_short.wav',
    AdhanSound.tone: 'sound/notification.wav',
  };

  @override
  void initState() {
    super.initState();
    _preview.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _previewing = null);
    });
  }

  @override
  void dispose() {
    _preview.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(AdhanSound sound) async {
    await _preview.stop();
    if (_previewing == sound) {
      setState(() => _previewing = null);
      return;
    }
    setState(() => _previewing = sound);
    await _preview.play(AssetSource(_soundAssets[sound]!));
  }

  Future<void> _setAdhanSound(AdhanSound sound) async {
    await _settings.setAdhanSound(sound);
    setState(() {});
    // الإشعارات المجدولة لازم تتجدول تاني على الـ channel بتاعة الصوت الجديد
    await PrayerNotifications.scheduleUpcoming();
  }

  Future<void> _setLanguage(String code) async {
    await _settings.setLanguage(code);
    // نصوص الإشعارات بتتكتب وقت الجدولة، فبنجدولها تاني باللغة الجديدة
    await AzkarNotifications.scheduleFromStorage();
    await PrayerNotifications.scheduleUpcoming();
  }

  Future<T?> _pickFromSheet<T>({
    required String title,
    required List<T> options,
    required String Function(T option) label,
    required bool Function(T option) isSelected,
    Widget? header,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 14.h),
              Text(
                title,
                style: GoogleFonts.amiri(
                  color: AppColors.primaryColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (header != null) header,
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final option in options)
                      ListTile(
                        onTap: () => Navigator.of(context).pop(option),
                        title: Text(
                          label(option),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        trailing: isSelected(option)
                            ? const Icon(
                                Icons.check,
                                color: AppColors.primaryColor,
                              )
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickMethod() async {
    final current = PrayerTimesService.method;
    final picked = await _pickFromSheet<PrayerMethodOption>(
      title: S.of(context).prayerCalculationMethod,
      options: kPrayerMethods,
      label: (m) => m.name,
      isSelected: (m) => m.key == current.key,
    );
    if (picked == null) return;
    await PrayerTimesService.setMethod(picked);
    setState(() {});
  }

  Future<void> _pickLocation() async {
    final current = PrayerTimesService.manualCity;
    bool useGps = false;
    final picked = await _pickFromSheet<PrayerCity>(
      title: S.of(context).location,
      options: kPrayerCities,
      label: (c) => c.name,
      isSelected: (c) => c.key == current?.key,
      header: Builder(
        builder: (sheetContext) => ListTile(
          onTap: () {
            useGps = true;
            Navigator.of(sheetContext).pop();
          },
          leading: const Icon(Icons.my_location, color: AppColors.primaryColor),
          title: Text(
            S.of(context).useMyLocation,
            style: TextStyle(color: AppColors.primaryColor, fontSize: 15.sp),
          ),
          trailing: current == null
              ? const Icon(Icons.check, color: AppColors.primaryColor)
              : null,
        ),
      ),
    );
    if (useGps) {
      final updated = await PrayerTimesService.updateLocation(request: true);
      if (updated) await PrayerNotifications.scheduleUpcoming();
      if (!mounted) return;
      setState(() {});
      if (!updated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).enableLocationHint)),
        );
      }
    } else if (picked != null) {
      await PrayerTimesService.setManualCity(picked);
      setState(() {});
    }
  }

  Future<void> _pickReciter() async {
    final current = selectedAyahReciter;
    final picked = await _pickFromSheet<AyahReciter>(
      title: S.of(context).defaultAyahReciter,
      options: kAyahReciters,
      label: (r) => r.name,
      isSelected: (r) => r.id == current.id,
    );
    if (picked == null) return;
    await saveAyahReciter(picked);
    setState(() {});
  }

  String get _locationLabel {
    final city = PrayerTimesService.manualCity;
    if (city != null) return city.name;
    return PrayerTimesService.usesDeviceLocation
        ? S.of(context).myLocation
        : S.of(context).defaultCity(S.of(context).defaultCityName);
  }

  @override
  Widget build(BuildContext context) {
    final method = PrayerTimesService.method;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: customAppBar(context, S.of(context).settings),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          SettingsSection(
            title: S.of(context).language,
            icon: Icons.language_rounded,
            children: [
              SegmentedChoice<String>(
                options: const {'ar': 'العربية', 'en': 'English'},
                selected: _settings.locale.value.languageCode,
                onChanged: _setLanguage,
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).adhanSound,
            icon: Icons.volume_up_rounded,
            children: [
              RadioGroup<AdhanSound>(
                groupValue: _settings.adhanSound,
                onChanged: (value) => _setAdhanSound(value!),
                child: Column(
                  children: [
                    for (final sound in AdhanSound.values)
                      RadioListTile<AdhanSound>(
                        value: sound,
                        activeColor: AppColors.primaryColor,
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          switch (sound) {
                            AdhanSound.full => S.of(context).adhanFull,
                            AdhanSound.short => S.of(context).adhanShort,
                            AdhanSound.tone => S.of(context).adhanTone,
                            AdhanSound.silent => S.of(context).adhanSilent,
                          },
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                        secondary: _soundAssets.containsKey(sound)
                            ? IconButton(
                                onPressed: () => _togglePreview(sound),
                                tooltip: S.of(context).listen,
                                icon: Icon(
                                  _previewing == sound
                                      ? Icons.stop_circle_outlined
                                      : Icons.play_circle_outline,
                                  color: AppColors.primaryColor,
                                ),
                              )
                            : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).prayerTimes,
            icon: Icons.access_time_rounded,
            children: [
              SettingsTile(
                title: S.of(context).calculationMethod,
                value: method.name,
                onTap: _pickMethod,
              ),
              SettingsTile(
                title: S.of(context).location,
                value: _locationLabel,
                onTap: _pickLocation,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: SegmentedChoice<bool>(
                  options: {
                    false: S.of(context).asrShafi,
                    true: S.of(context).asrHanafi,
                  },
                  selected: PrayerTimesService.isHanafi,
                  onChanged: (hanafi) async {
                    await PrayerTimesService.setHanafi(hanafi);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).adhanPerPrayer,
            icon: Icons.notifications_active_rounded,
            children: [
              for (int prayer = 0; prayer < 5; prayer++)
                SwitchListTile(
                  value: PrayerNotifications.isPrayerEnabled(prayer),
                  onChanged: (enabled) async {
                    await PrayerNotifications.setPrayerEnabled(prayer, enabled);
                    setState(() {});
                  },
                  activeThumbColor: AppColors.primaryColor,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    S.of(context).prayerName(prayerDisplayName(prayer)),
                    style: TextStyle(color: Colors.white, fontSize: 15.sp),
                  ),
                ),
              SizedBox(height: 6.h),
              Text(
                S.of(context).reminderBeforePrayer,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              SizedBox(height: 6.h),
              Wrap(
                spacing: 8.w,
                children: [
                  for (final minutes in PrayerNotifications.reminderOptions)
                    ChoiceChip(
                      label: Text(minutes == 0
                          ? S.of(context).off
                          : S.of(context).minutesCount(minutes)),
                      selected: PrayerNotifications.reminderMinutes == minutes,
                      onSelected: (_) async {
                        await PrayerNotifications.setReminderMinutes(minutes);
                        setState(() {});
                      },
                      selectedColor: AppColors.primaryColor,
                      backgroundColor: Colors.black,
                      labelStyle: TextStyle(
                        color: PrayerNotifications.reminderMinutes == minutes
                            ? AppColors.backgroundColor
                            : Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ),
          SettingsSection(
            title: S.of(context).reading,
            icon: Icons.menu_book_rounded,
            children: [
              Text(
                S.of(context).quranFontSize,
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              Slider(
                value: _settings.quranFontSize,
                min: AppSettings.minFontSize,
                max: AppSettings.maxFontSize,
                divisions: 8,
                activeColor: AppColors.primaryColor,
                label: _settings.quranFontSize.round().toString(),
                onChanged: (size) async {
                  await _settings.setQuranFontSize(size);
                  setState(() {});
                },
              ),
              Text(
                'بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ',
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  color: AppColors.primaryColor,
                  fontSize: _settings.quranFontSize.sp,
                ),
              ),
              SettingsTile(
                title: S.of(context).defaultAyahReciter,
                value: selectedAyahReciter.name,
                onTap: _pickReciter,
              ),
              SwitchListTile(
                value: _settings.showTranslation,
                onChanged: (show) async {
                  await _settings.setShowTranslation(show);
                  setState(() {});
                },
                activeThumbColor: AppColors.primaryColor,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  S.of(context).showEnglishTranslation,
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
                subtitle: Text(
                  'Saheeh International',
                  style: TextStyle(color: Colors.white54, fontSize: 12.sp),
                ),
              ),
            ],
          ),
          const AboutSection(),
        ],
      ),
    );
  }
}
