import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.hintText = 'Enter text here',
    this.onChanged,
  });
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: TextStyle(
        color: AppColors.text,
        fontWeight: FontWeight.w500,
        fontSize: 16.sp,
        decoration: TextDecoration.none,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.card,
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.textFaint,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
        ),

        prefixIcon: Icon(
          Icons.menu_book_rounded,
          color: AppColors.primaryColor,
        ), // Suffix icon
        border: customBorder(),
        focusedBorder: customBorder(),
        enabledBorder: customBorder(),
      ),
    );
  }

  OutlineInputBorder customBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.0), // Rounded border on focus

      borderSide: BorderSide(color: AppColors.primaryColor, width: 1.5),
    );
  }
}
