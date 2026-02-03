import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';

class AyahWidget extends StatelessWidget {
  const AyahWidget({super.key, required this.ayahs});
  final Ayahs ayahs;
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      GestureDetector(
          onLongPress: () {
            _showLongPressDialog(context: context,ayahs: ayahs);
            log("onLongPress");
          },
          child: Text(
            ayahs.text!,
            style: GoogleFonts.amiri(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor),
          )),
      AyahNumber(
        number: ayahs.numberInSurah!,
        size: 15,
        volum: 30,
      ),
    ]);
  }

  void _showLongPressDialog({required BuildContext context, required Ayahs ayahs}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ayahs.text!),
          content: SingleChildScrollView(child: Text("${ayahs.tafseer}")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
