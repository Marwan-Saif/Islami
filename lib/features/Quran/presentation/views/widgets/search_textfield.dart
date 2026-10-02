import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';

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
      style:  TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          decoration: TextDecoration.none),
      decoration: InputDecoration(
        fillColor: Colors.white,
        hintText: hintText,
        hintStyle:  TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16.sp),

        prefixIcon: Padding(
          padding:
              const EdgeInsetsDirectional.only(start: 8.0, top: 9, bottom: 9),
          child: Image.asset(Assets.imagesQuranIcon),
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

      borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
    );
  }
}
