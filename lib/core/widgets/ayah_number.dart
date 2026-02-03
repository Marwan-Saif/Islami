import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_images.dart';

class AyahNumber extends StatelessWidget {
  const AyahNumber({
    super.key,
    required this.number,
    this.size, this.volum,
  });
  final int number;
  final double? size;
  final double? volum;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Image.asset(
          Assets.imagesAyahNumber,
          height: volum,
        ),
        Text(
          number.toString(),
          style: TextStyle(
              color: Colors.white,
              fontSize: size ?? 20.sp,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
