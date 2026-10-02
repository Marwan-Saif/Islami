import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.primaryColor.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryColor, size: 22.r),
              SizedBox(width: 8.w),
              Text(
                title,
                style: GoogleFonts.amiri(
                  color: AppColors.primaryColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ...children,
        ],
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.icon,
  });
  final String title;
  final String? value;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: icon == null ? null : Icon(icon, color: AppColors.primaryColor),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 15.sp),
      ),
      subtitle: value == null
          ? null
          : Text(
              value!,
              style: TextStyle(color: Colors.white54, fontSize: 13.sp),
            ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.white38,
        size: 16.r,
      ),
    );
  }
}

/// اختيار من اتنين أو تلاتة بشكل أزرار جنب بعض
class SegmentedChoice<T> extends StatelessWidget {
  const SegmentedChoice({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });
  final Map<T, String> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final entry in options.entries)
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: InkWell(
                onTap: () => onChanged(entry.key),
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: entry.key == selected
                        ? AppColors.primaryColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: AppColors.primaryColor),
                  ),
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: entry.key == selected
                          ? AppColors.backgroundColor
                          : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
