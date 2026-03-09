import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/services/audio_services.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Radio/data/models/audio_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class RadioView extends StatefulWidget {
  const RadioView({super.key});

  @override
  State<RadioView> createState() => _RadioViewState();
}

class _RadioViewState extends State<RadioView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),

            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.radio_rounded,
                    color: AppColors.primaryColor,
                    size: 45.sp,
                  ),
                  Text(
                    'الراديو والتلاوات',
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),

            const LiveRadioCard(),

            SizedBox(height: 30.h),

            Text(
              'المكتبة الصوتية',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 16.h),

            _buildSelectionCard(
              title: 'اختيار القارئ',
              subtitle: 'اختر شيخك المفضل للاستماع',
              icon: Icons.person_search_rounded,
              onTap: () {
                print("تم الضغط على اختيار القارئ");
              },
            ),

            SizedBox(height: 16.h),

            _buildSelectionCard(
              title: 'اختيار التلاوة',
              subtitle: 'اختر السورة أو الجزء المطلوب',
              icon: Icons.menu_book_rounded,
              onTap: () {
                print("تم الضغط على اختيار التلاوة");
              },
            ),

            SizedBox(height: 120.h), // مساحة أمان للـ Bottom Nav Bar
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      splashColor: AppColors.primaryColor.withOpacity(0.2),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(icon, color: AppColors.primaryColor, size: 30.sp),
            ),

            SizedBox(width: 20.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ],
              ),
            ),

            // سهم الدخول
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// LiveRadioCard
// ==========================================
class LiveRadioCard extends StatefulWidget {
  const LiveRadioCard({super.key});

  @override
  State<LiveRadioCard> createState() => _LiveRadioCardState();
}

class _LiveRadioCardState extends State<LiveRadioCard> {
  // أخذ نسخة من السيرفس (Singleton) اللي عملناه في الـ Canvas
  final AudioService _audioService = AudioService();

  // تجهيز الـ Playlist كمتغير عشان نقدر نقارن بيه في الـ UI
  final List<AudioModel> playlist = [
    AudioModel(
      id: 'surah_1',
      title: 'سورة الفاتحة',
      subtitle: 'عبد الباري محمد',
      url: "https://backup.qurango.net/radio/abdulbari_mohammad",
    ),
    AudioModel(
      id: 'surah_2',
      title: 'سورة البقرة',
      subtitle: 'عبد الله بصفر',
      url: "https://backup.qurango.net/radio/abdullah_basfer",
    ),
    AudioModel(
      id: 'surah_3',
      title: 'سورة آل عمران',
      subtitle: 'عبد الله خياط',
      url: "https://backup.qurango.net/radio/abdullah_khayyat",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor.withOpacity(0.9),
            AppColors.primaryColor.withOpacity(0.5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.mosque_rounded,
              size: 150.sp,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: StreamBuilder<SequenceState?>(
              // 1. هنا بنراقب إيه اللي شغال دلوقتي في المشغل بالكامل
              stream: _audioService.audioPlayer.sequenceStateStream,
              builder: (context, sequenceSnapshot) {
                final currentTag = sequenceSnapshot.data?.currentSource?.tag;
                final MediaItem? currentMediaItem = currentTag is MediaItem ? currentTag : null;

                // 2. بنحدد النصوص: لو في حاجة شغالة نعرضها، لو مفيش نعرض أول عنصر في الـ Playlist
                final String displayTitle = currentMediaItem?.title ?? playlist.first.title;
                final String displaySubtitle = currentMediaItem?.artist ?? playlist.first.subtitle;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // النصوص بقت تتغير ديناميكياً
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displaySubtitle, // اسم القارئ (مثل: عبد الباري محمد)
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          displayTitle, // اسم السورة أو الإذاعة (مثل: سورة الفاتحة)
                          style: GoogleFonts.amiri(
                            color: Colors.black,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // زرار التشغيل
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: StreamBuilder<PlayerState>(
                        stream: _audioService.audioPlayer.playerStateStream,
                        builder: (context, playerSnapshot) {
                          final playerState = playerSnapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing ?? false;

                          final bool isLoading = processingState == ProcessingState.loading || processingState == ProcessingState.buffering;

                          // 1. حالة التحميل
                          if (isLoading) {
                            return _buildPlayButton(
                              child: Padding(
                                padding: EdgeInsets.all(15.w),
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          } 
                          // 2. حالة التشغيل (يعرض Pause)
                          else if (playing) {
                            return _buildPlayButton(
                              icon: Icons.pause_rounded,
                              onTap: _audioService.pauseAudio,
                            );
                          } 
                          // 3. حالة الإيقاف أو البداية (يعرض Play)
                          else {
                            return _buildPlayButton(
                              icon: Icons.play_arrow_rounded,
                              onTap: () async {
                                if (currentMediaItem != null) {
                                  // لو في ملف محمل فعلاً لكن متوقف، كمل تشغيله
                                  await _audioService.audioPlayer.play();
                                } else {
                                  // لو مفيش أي حاجة شغالة، ابدأ القائمة من الأول
                                  await _audioService.playList(playlist);
                                }
                              },
                            );
                          }
                        },
                      )
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم الزرار الدائري بأسلوب نظيف
  Widget _buildPlayButton({IconData? icon, Widget? child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: child ?? Icon(icon, color: AppColors.primaryColor, size: 35.sp),
      ),
    );
  }
}