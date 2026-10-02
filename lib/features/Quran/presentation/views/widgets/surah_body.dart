import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/app_settings.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/views/widgets/ayah_actions_sheet.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// السورة مقسمة لصفحات المصحف، والـ list بتبني الصفحات اللي ظاهرة بس
/// (قبل كده السورة كلها كانت Text.rich واحد، والبقرة كانت بتتعمل layout مرة واحدة)
class SurahBody extends StatefulWidget {
  const SurahBody({super.key, required this.surahNumber, this.initialAyah});

  final int surahNumber;
  final int? initialAyah;

  @override
  State<SurahBody> createState() => _SurahBodyState();
}

class _SurahBodyState extends State<SurahBody> {
  late final List<List<Ayah>> _pages;
  late final int _initialIndex;

  // متابعة التلاوة: الصفحة بتتحسب اتقرت لو آخرها ظهر على الشاشة
  // وفضلت ظاهرة 4 ثواني على الأقل (عشان الفتح والقفل بسرعة ميتحسبش)
  static const Duration _minReadTime = Duration(seconds: 4);
  final ItemPositionsListener _positions = ItemPositionsListener.create();
  final Map<int, DateTime> _firstSeen = {};
  final Set<int> _markedPages = {};
  Timer? _readTimer;

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_checkReadPages);
    // لو المستخدم واقف على صفحة من غير scroll الـ listener مش هيتنده
    _readTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _checkReadPages(),
    );
    final ayahs = getit.get<QuranRepo>().getAyahs(widget.surahNumber);
    _pages = [];
    for (final ayah in ayahs) {
      if (_pages.isEmpty || _pages.last.last.page != ayah.page) {
        _pages.add([ayah]);
      } else {
        _pages.last.add(ayah);
      }
    }
    final targetAyah = widget.initialAyah;
    final pageIndex = targetAyah == null
        ? -1
        : _pages.indexWhere(
            (page) => page.any((ayah) => ayah.id == targetAyah),
          );
    // عنصر 0 هو رأس السورة
    _initialIndex = pageIndex < 0 ? 0 : pageIndex + 1;
  }

  void _checkReadPages() {
    final now = DateTime.now();
    for (final position in _positions.itemPositions.value) {
      if (position.index == 0) continue;
      final visible =
          position.itemLeadingEdge < 1 && position.itemTrailingEdge > 0;
      if (!visible) continue;
      final page = _pages[position.index - 1].first.page;
      final seen = _firstSeen.putIfAbsent(page, () => now);
      final endVisible = position.itemTrailingEdge <= 1;
      if (endVisible &&
          now.difference(seen) >= _minReadTime &&
          _markedPages.add(page)) {
        ReadingTracker.instance.markPageRead(page).then((completedKhatma) {
          if (completedKhatma && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('مبارك! أتممت ختمة كاملة للقرآن الكريم'),
              ),
            );
          }
        });
      }
    }
  }

  // أول آية في أعلى صفحة ظاهرة
  ReadingPosition? get _currentPosition {
    final visible =
        _positions.itemPositions.value
            .where((p) => p.index > 0 && p.itemTrailingEdge > 0)
            .toList()
          ..sort((a, b) => a.index.compareTo(b.index));
    if (visible.isEmpty) return null;
    final ayah = _pages[visible.first.index - 1].first;
    return ReadingPosition(
      surah: widget.surahNumber,
      ayah: ayah.id,
      page: ayah.page,
    );
  }

  @override
  void dispose() {
    _readTimer?.cancel();
    _positions.itemPositions.removeListener(_checkReadPages);
    final position = _currentPosition;
    if (position != null) ReadingTracker.instance.saveLastRead(position);
    super.dispose();
  }

  void _showAyahActions(Ayah ayah) {
    showAyahActionsSheet(context, surahNumber: widget.surahNumber, ayah: ayah);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SequenceState?>(
      stream: AudioService().audioPlayer.sequenceStateStream,
      builder: (context, snapshot) {
        final tag = snapshot.data?.currentSource?.tag;
        final playingAyah = tag is MediaItem
            ? ayahFromAudioId(tag.id, widget.surahNumber)
            : null;
        return ValueListenableBuilder<int>(
          // حجم الخط والترجمة من الإعدادات
          valueListenable: AppSettings.instance.readingChanges,
          builder: (context, _, _) {
            final settings = AppSettings.instance;
            final translation = settings.showTranslation
                ? getit.get<QuranRepo>().getTranslation(widget.surahNumber)
                : null;
            return ScrollablePositionedList.builder(
              initialScrollIndex: _initialIndex,
              itemPositionsListener: _positions,
              itemCount: _pages.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _SurahHeader(surahNumber: widget.surahNumber);
                }
                final page = _pages[index - 1];
                return _QuranPage(
                  ayahs: page,
                  fontSize: settings.quranFontSize,
                  translation: translation,
                  highlightedAyah: page.any((ayah) => ayah.id == playingAyah)
                      ? playingAyah
                      : null,
                  onAyahLongPress: _showAyahActions,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _SurahHeader extends StatelessWidget {
  const _SurahHeader({required this.surahNumber});
  final int surahNumber;

  static final String _basmala = cleanAyahText(
    QuranService.instance.getAyah(1, 1).text,
  );

  @override
  Widget build(BuildContext context) {
    final meta = QuranService.instance.getSurahMetadata(surahNumber);
    final place = meta.revelationType == 'Medinan' ? 'مدنية' : 'مكية';
    // الفاتحة البسملة آية منها، والتوبة من غير بسملة
    final showBasmala = surahNumber != 1 && surahNumber != 9;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        children: [
          Text(
            '$place • ${ayahCountLabel(meta.ayahCount)}',
            style: TextStyle(color: Colors.white54, fontSize: 13.sp),
          ),
          if (showBasmala) ...[
            SizedBox(height: 8.h),
            Text(
              _basmala,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                color: AppColors.primaryColor,
                fontSize: 24.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuranPage extends StatefulWidget {
  const _QuranPage({
    required this.ayahs,
    required this.fontSize,
    required this.translation,
    required this.highlightedAyah,
    required this.onAyahLongPress,
  });

  final List<Ayah> ayahs;
  final double fontSize;

  /// null لو الترجمة مقفولة من الإعدادات
  final Map<int, String>? translation;
  final int? highlightedAyah;
  final void Function(Ayah ayah) onAyahLongPress;

  @override
  State<_QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<_QuranPage> {
  // الـ recognizers لازم تتعمل dispose، فمش بتتعمل جوه build
  final Map<int, LongPressGestureRecognizer> _recognizers = {};

  LongPressGestureRecognizer _recognizerFor(Ayah ayah) =>
      _recognizers.putIfAbsent(
        ayah.id,
        () =>
            LongPressGestureRecognizer()
              ..onLongPress = () => widget.onAyahLongPress(ayah),
      );

  @override
  void dispose() {
    for (final recognizer in _recognizers.values) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final first = widget.ayahs.first;
    final textStyle = GoogleFonts.amiri(
      fontSize: widget.fontSize.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.primaryColor,
      height: 1.9,
    );
    return Column(
      children: [
        Text.rich(
          TextSpan(
            children: [
              for (final ayah in widget.ayahs) ...[
                TextSpan(
                  text: '${cleanAyahText(ayah.text)} ',
                  recognizer: _recognizerFor(ayah),
                  style: ayah.id == widget.highlightedAyah
                      ? textStyle.copyWith(
                          backgroundColor: AppColors.primaryColor.withValues(
                            alpha: 0.18,
                          ),
                        )
                      : textStyle,
                ),
                if (ayah.isSajda) TextSpan(text: '۩ ', style: textStyle),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AyahNumber(number: ayah.id),
                ),
                const TextSpan(text: ' '),
              ],
            ],
          ),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.rtl,
        ),
        if (widget.translation != null)
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final ayah in widget.ayahs)
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      '(${ayah.id}) ${widget.translation![ayah.id] ?? ''}',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13.sp,
                        height: 1.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        _PageFooter(page: first.page, juz: first.juz),
      ],
    );
  }
}

class _PageFooter extends StatelessWidget {
  const _PageFooter({required this.page, required this.juz});
  final int page;
  final int juz;

  @override
  Widget build(BuildContext context) {
    final divider = Expanded(
      child: Divider(color: AppColors.primaryColor.withValues(alpha: 0.35)),
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          divider,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              'صفحة $page • الجزء $juz',
              style: TextStyle(
                color: AppColors.primaryColor.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ),
            ),
          ),
          divider,
        ],
      ),
    );
  }
}
