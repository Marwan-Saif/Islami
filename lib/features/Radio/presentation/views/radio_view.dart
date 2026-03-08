import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';

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
                  Icon(Icons.radio_rounded, color: AppColors.primaryColor, size: 45.sp),
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
          border: Border.all(color: AppColors.primaryColor.withOpacity(0.3), width: 1.5),
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
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 13.sp,
                    ),
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  
  
  final String radioUrl = 'https://backup.qurango.net/radio/abdulbasit_abdulsamad_mojawwad';

  @override
  void dispose() {
    _audioPlayer.dispose(); 
    super.dispose();
  }

  Future<void> _toggleRadio() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        setState(() {
          isLoading = true; 
        });
        await _audioPlayer.play(UrlSource(radioUrl));
        setState(() {
          isPlaying = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        isPlaying = false;
      });
      print("Error playing radio: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: 180.h,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'البث المباشر',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'عبد الباسط عبد الصمد',
                      style: GoogleFonts.amiri(
                        color: Colors.black,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: InkWell(
                    onTap: isLoading ? null : _toggleRadio, 
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: isLoading 
                          ? Padding(
                              padding: EdgeInsets.all(15.w),
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                                strokeWidth: 3,
                              ),
                            )
                          : Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: AppColors.primaryColor,
                              size: 35.sp,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}