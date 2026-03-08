import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'dart:math' as math;

// import 'package:flutter_qibla/flutter_qibla.dart'; // باكدج القبلة
import 'package:islami/core/utils/app_images.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with SingleTickerProviderStateMixin {
  // final Color AppColors.primaryColor = const Color(0xFFC9A063);
  
  // الأنيميشن الخاص بالنبض (Glow)
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // تشغيل الأنيميشن وتكراره
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          
          // العنوان
          Text(
            'اتجاه القبلة',
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const Spacer(),

          // بناء البوصلة واستقبال البيانات من الحساس
          StreamBuilder<QiblahDirection>(
            stream: FlutterQiblah.qiblahStream,
            builder: (context, snapshot) {
              // لو لسه بيحمل أو مفيش بيانات
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primaryColor),
                );
              }

              // زاوية القبلة (بنجيبها من الباكدج وبنحولها لـ Radians)
              // لو مفيش بيانات هنخليها 0 مؤقتاً
              final qiblaDirection = snapshot.data;
              final double qiblaAngle = (qiblaDirection != null) 
                  ? (qiblaDirection.qiblah * (math.pi / 180)) 
                  : 0.0;

              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // 1. التوهج الذهبي (الآن يظهر بوضوح)
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Container(
                          width: 220.w,
                          height: 220.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // وضعنا لون داكن متطابق مع الخلفية حتى ينعكس الظل
                            color:  Color(0xFF1A1512), 
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryColor.withOpacity(0.8 * _pulseAnimation.value),
                                blurRadius: 60 * _pulseAnimation.value, // تكبير الانتشار
                                spreadRadius: 15 * _pulseAnimation.value,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // 2. الإطار الخارجي للبوصلة (ثابت)
                    Container(
                      width: 300.w,
                      height: 300.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryColor.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          _buildDirectionMarker(Alignment.topCenter, 'N'),
                          _buildDirectionMarker(Alignment.bottomCenter, 'S'),
                          _buildDirectionMarker(Alignment.centerRight, 'E'),
                          _buildDirectionMarker(Alignment.centerLeft, 'W'),
                        ],
                      ),
                    ),

                    // 3. النجمة/الإبرة الدوارة (تتحرك مع حركة الموبايل)
                    Transform.rotate(
                      angle: qiblaAngle, // الزاوية الحقيقية للقبلة من الحساس
                      child: Container(
                        width: 240.w,
                        height: 240.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: const DecorationImage(
                            image: AssetImage("assets/images/compass1.png"), // صورة الإبرة أو النجمة
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    // // 4. أيقونة المنتصف (ثابتة)
                    // Container(
                    //   width: 60.w,
                    //   height: 60.w,
                    //   decoration: BoxDecoration(
                    //     color: const Color(0xFF1A1512),
                    //     shape: BoxShape.circle,
                    //     border: Border.all(color: AppColors.primaryColor, width: 2),
                    //     boxShadow: [
                    //       BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 10),
                    //     ],
                    //   ),
                    //   child: Center(
                    //     child: Icon(
                    //       Icons.mosque_rounded, // الكعبة أو المسجد
                    //       color: AppColors.primaryColor,
                    //       size: 30.sp,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 60.h),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.primaryColor.withOpacity(0.4)),
            ),
            child: Text(
              'أدر الجهاز لتحديد اتجاه القبلة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const Spacer(),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  Widget _buildDirectionMarker(Alignment alignment, String label) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primaryColor.withOpacity(0.6),
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}