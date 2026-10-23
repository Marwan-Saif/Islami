import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/brand/pattern_background.dart';
import 'package:islami/features/Timer/domain/zekr_entity.dart';

/// أيقونة كل نوع أذكار بنفس ترتيب kFiles
/// (بدل صورة الهلال الدهبي اللي كانت واحدة لكل الكروت)
const List<IconData> kAzkarIcons = [
  Icons.wb_sunny_rounded, // الصباح
  Icons.nights_stay_rounded, // المساء
  Icons.front_hand_rounded, // الصلاة
  Icons.mosque_rounded, // المسجد
  Icons.auto_awesome_rounded, // بعد الصلاة
  Icons.wb_twilight_rounded, // الاستيقاظ
  Icons.restaurant_rounded, // الطعام
  Icons.bedtime_rounded, // النوم
];

class ZekrCard extends StatelessWidget {
  const ZekrCard({
    super.key,
    required this.name,
    required this.zekrList,
    required this.icon,
  });
  final String name;
  final List<ZekrEntity> zekrList;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRouter.zekrScreen,
          extra: {"azkarList": zekrList, "title": name},
        ),
        child: Container(
          width: 140.sp,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.primaryColor.withValues(alpha: 0.45),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: IslamicPatternLayer(opacity: 0.8)),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64.r,
                      height: 64.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Icon(icon, color: AppColors.onPrimary, size: 32.r),
                    ),
                    SizedBox(height: 12.h),
                    // الكارت ارتفاعه ثابت، فالاسم بياخد اللي فاضل ويتقص بدل overflow
                    // (شاشة صغيرة مع خط مكبر)
                    Flexible(
                      child: Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          color: AppColors.text,
                          fontSize: 18.sp,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
}
