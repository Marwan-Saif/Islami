import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/core/utils/quran_utils.dart';
import 'package:islami/features/Radio/presentation/views/widgets/recitation_scaffold.dart';
import 'package:islami/generated/l10n.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class ReciterSurahsView extends StatelessWidget {
  const ReciterSurahsView({
    super.key,
    required this.reciter,
    required this.moshaf,
  });
  final ReciterModel reciter;
  final MoshafModel moshaf;

  Future<void> _play(int index) async {
    try {
      await AudioService().playList(moshaf.toPlaylist(reciter), initialIndex: index);
    } catch (e) {
      debugPrint('failed to play recitation: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RecitationScaffold(
      title: S.of(context).recitations,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Text(
              reciter.name,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                color: AppColors.primaryColor,
                fontSize: 26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              moshaf.name,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _HeaderButton(
                    icon: Icons.play_arrow_rounded,
                    label: S.of(context).playAll,
                    filled: true,
                    onTap: () => _play(0),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _HeaderButton(
                    icon: Icons.swap_horiz_rounded,
                    label: S.of(context).changeReciter,
                    onTap: () => context.pushReplacement(AppRouter.recitersView),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: StreamBuilder<SequenceState?>(
                stream: AudioService().audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final tag = snapshot.data?.currentSource?.tag;
                  final currentId = tag is MediaItem ? tag.id : null;
                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 12.h),
                    itemCount: moshaf.surahList.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.white12,
                      height: 1,
                      indent: 40.w,
                      endIndent: 40.w,
                    ),
                    itemBuilder: (context, index) {
                      final surah = moshaf.surahList[index];
                      return SurahAudioTile(
                        surahNumber: surah,
                        isCurrent: currentId == moshaf.audioId(reciter, surah),
                        onTap: () => _play(index),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SurahAudioTile extends StatelessWidget {
  const SurahAudioTile({
    super.key,
    required this.surahNumber,
    required this.isCurrent,
    required this.onTap,
  });
  final int surahNumber;
  final bool isCurrent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
        child: Row(
          children: [
            AyahNumber(number: surahNumber),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                surahTitle(surahNumber),
                style: GoogleFonts.amiri(
                  color: isCurrent ? AppColors.primaryColor : Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Icon(
              isCurrent ? Icons.graphic_eq_rounded : Icons.play_circle_outline_rounded,
              color: AppColors.primaryColor,
              size: 28.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? AppColors.backgroundColor : AppColors.primaryColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: filled ? AppColors.primaryColor : Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.primaryColor, width: 1.5),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foreground, size: 22.r),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
