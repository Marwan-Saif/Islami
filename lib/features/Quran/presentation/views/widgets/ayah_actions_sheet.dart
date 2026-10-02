import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/features/Quran/data/ayah_reciters.dart';
import 'package:islami/features/Quran/data/reading_tracker.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Radio/data/models/audio_model.dart';
import 'package:islami/generated/l10n.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

const String _ayahReciterKey = 'ayah_reciter';

AyahReciter get selectedAyahReciter =>
    ayahReciterById(Prefs.getData(key: _ayahReciterKey));

Future<void> saveAyahReciter(AyahReciter reciter) =>
    Prefs.saveData(key: _ayahReciterKey, value: reciter.id);

String _audioId(int surah, int ayah, AyahReciter reciter) =>
    'ayah_${surah}_${ayah}_${reciter.id}';

/// رقم الآية لو الصوت الشغال آية من نفس السورة (عشان نعلّم عليها)
int? ayahFromAudioId(String id, int surahNumber) {
  final parts = id.split('_');
  if (parts.length < 3 || parts[0] != 'ayah') return null;
  if (int.tryParse(parts[1]) != surahNumber) return null;
  return int.tryParse(parts[2]);
}

AudioModel _ayahAudio(int surah, int ayah, AyahReciter reciter) => AudioModel(
      id: _audioId(surah, ayah, reciter),
      title: S.current.ayahRef(surahTitle(surah), ayah),
      subtitle: reciter.name,
      url: reciter.ayahUrl(surah, ayah),
    );

Future<void> showAyahActionsSheet(
  BuildContext context, {
  required int surahNumber,
  required Ayah ayah,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
    ),
    builder: (context) => ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: _AyahActions(surahNumber: surahNumber, ayah: ayah),
    ),
  );
}

class _AyahActions extends StatefulWidget {
  const _AyahActions({required this.surahNumber, required this.ayah});
  final int surahNumber;
  final Ayah ayah;

  @override
  State<_AyahActions> createState() => _AyahActionsState();
}

class _AyahActionsState extends State<_AyahActions> {
  bool _showTafsir = false;
  AyahReciter _reciter = selectedAyahReciter;
  late bool _bookmarked = ReadingTracker.instance
      .isBookmarked(widget.surahNumber, widget.ayah.id);

  Future<void> _toggleBookmark() async {
    final added = await ReadingTracker.instance.toggleBookmark(ReadingPosition(
      surah: widget.surahNumber,
      ayah: widget.ayah.id,
      page: widget.ayah.page,
    ));
    if (!mounted) return;
    setState(() => _bookmarked = added);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          added ? S.of(context).bookmarkAdded : S.of(context).bookmarkRemoved),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _playAyah() async {
    Navigator.of(context).pop();
    await AudioService()
        .playSingle(_ayahAudio(widget.surahNumber, widget.ayah.id, _reciter));
  }

  Future<void> _playFromHere() async {
    Navigator.of(context).pop();
    final count = QuranService.instance.getVerseCount(widget.surahNumber);
    await AudioService().playList([
      for (int ayah = widget.ayah.id; ayah <= count; ayah++)
        _ayahAudio(widget.surahNumber, ayah, _reciter),
    ]);
  }

  Future<void> _copy() async {
    final text =
        '${cleanAyahText(widget.ayah.text)} [${surahTitleArabic(widget.surahNumber)}: ${widget.ayah.id}]';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).ayahCopied)),
    );
  }

  Future<void> _pickReciter() async {
    final picked = await showModalBottomSheet<AyahReciter>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      builder: (context) => ListView(
        children: [
          for (final reciter in kAyahReciters)
            ListTile(
              onTap: () => Navigator.of(context).pop(reciter),
              title: Text(reciter.name,
                  style: TextStyle(color: Colors.white, fontSize: 15.sp)),
              trailing: reciter.id == _reciter.id
                  ? const Icon(Icons.check, color: AppColors.primaryColor)
                  : null,
            ),
        ],
      ),
    );
    if (picked == null) return;
    await saveAyahReciter(picked);
    setState(() => _reciter = picked);
  }

  @override
  Widget build(BuildContext context) {
    final tafsir =
        getit.get<QuranRepo>().getTafsir(widget.surahNumber)[widget.ayah.id];
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).ayahRefDot(surahTitle(widget.surahNumber), widget.ayah.id),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              cleanAyahText(widget.ayah.text),
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                color: AppColors.primaryColor,
                fontSize: 20.sp,
                height: 1.8,
              ),
            ),
            const Divider(color: Colors.white12),
            _ActionTile(
              icon: Icons.record_voice_over_rounded,
              title: S.of(context).reciterLabel(_reciter.name),
              onTap: _pickReciter,
            ),
            _ActionTile(
              icon: Icons.play_circle_outline_rounded,
              title: S.of(context).listenToAyah,
              onTap: _playAyah,
            ),
            _ActionTile(
              icon: Icons.playlist_play_rounded,
              title: S.of(context).playFromHere,
              onTap: _playFromHere,
            ),
            _ActionTile(
              icon: Icons.menu_book_rounded,
              title: _showTafsir
                  ? S.of(context).hideTafsir
                  : S.of(context).tafsirMuyassar,
              onTap: () => setState(() => _showTafsir = !_showTafsir),
            ),
            if (_showTafsir)
              Container(
                padding: EdgeInsets.all(14.r),
                margin: EdgeInsets.symmetric(vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  tafsir ?? S.of(context).tafsirUnavailable,
                  style: TextStyle(
                      color: Colors.white, fontSize: 15.sp, height: 1.7),
                ),
              ),
            _ActionTile(
              icon: _bookmarked
                  ? Icons.bookmark_remove_rounded
                  : Icons.bookmark_add_rounded,
              title: _bookmarked
                  ? S.of(context).removeBookmark
                  : S.of(context).addBookmark,
              onTap: _toggleBookmark,
            ),
            _ActionTile(
              icon: Icons.copy_rounded,
              title: S.of(context).copyAyah,
              onTap: _copy,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.title, required this.onTap});
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16.sp)),
    );
  }
}
