import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

/// مشغل صغير بيظهر تحت شاشات التلاوات طول ما فيه حاجة متحملة في المشغل
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    final player = AudioService().audioPlayer;
    return StreamBuilder<SequenceState?>(
      stream: player.sequenceStateStream,
      builder: (context, snapshot) {
        final tag = snapshot.data?.currentSource?.tag;
        if (tag is! MediaItem) return const SizedBox.shrink();

        return Container(
          margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tag.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.amiri(
                            color: AppColors.primaryColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          tag.artist ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  ),
                  _ControlButton(
                    // في الـ RTL "السابق" على اليمين، فبنستخدم سهم التالي في شكله
                    icon: Icons.skip_next_rounded,
                    tooltip: 'السابق',
                    onTap: player.hasPrevious ? player.seekToPrevious : null,
                  ),
                  const _PlayPauseButton(),
                  _ControlButton(
                    icon: Icons.skip_previous_rounded,
                    tooltip: 'التالي',
                    onTap: player.hasNext ? player.seekToNext : null,
                  ),
                ],
              ),
              const _ProgressBar(),
            ],
          ),
        );
      },
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton();

  @override
  Widget build(BuildContext context) {
    final player = AudioService().audioPlayer;
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final state = snapshot.data;
        final loading = state?.processingState == ProcessingState.loading ||
            state?.processingState == ProcessingState.buffering;
        final playing = state?.playing ?? false;

        return Container(
          width: 46.r,
          height: 46.r,
          margin: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: loading
              ? Padding(
                  padding: EdgeInsets.all(12.r),
                  child: const CircularProgressIndicator(
                    color: AppColors.backgroundColor,
                    strokeWidth: 2.5,
                  ),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: playing ? 'إيقاف مؤقت' : 'تشغيل',
                  onPressed: playing ? player.pause : player.play,
                  icon: Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: AppColors.backgroundColor,
                    size: 30.r,
                  ),
                ),
        );
      },
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({required this.icon, required this.tooltip, this.onTap});
  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, size: 30.r),
      color: AppColors.primaryColor,
      disabledColor: Colors.white24,
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    final player = AudioService().audioPlayer;
    return StreamBuilder<Duration>(
      stream: player.positionStream,
      builder: (context, snapshot) {
        final duration = player.duration ?? Duration.zero;
        final position = snapshot.data ?? Duration.zero;
        final max = duration.inMilliseconds.toDouble();
        final value = position.inMilliseconds.clamp(0, max.toInt()).toDouble();

        return Row(
          children: [
            Text(_format(position), style: _timeStyle),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2.5,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                ),
                child: Slider(
                  value: max > 0 ? value : 0,
                  max: max > 0 ? max : 1,
                  activeColor: AppColors.primaryColor,
                  inactiveColor: Colors.white24,
                  onChanged: max > 0
                      ? (newValue) =>
                          player.seek(Duration(milliseconds: newValue.toInt()))
                      : null,
                ),
              ),
            ),
            Text(_format(duration), style: _timeStyle),
          ],
        );
      },
    );
  }

  TextStyle get _timeStyle => TextStyle(color: Colors.white54, fontSize: 11.sp);

  String _format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return duration.inHours > 0
        ? '${duration.inHours}:$minutes:$seconds'
        : '$minutes:$seconds';
  }
}
