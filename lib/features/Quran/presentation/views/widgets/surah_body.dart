import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/widgets/ayah_number.dart';
import 'package:islami/features/Quran/data/models/surah_model.dart';

class SurahBody extends StatelessWidget {
  const SurahBody({super.key, required this.ayahs});

  final List<Ayahs> ayahs;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        // بنخلي أقل طول للكونتينر هو طول الشاشة عشان الـ Center يشتغل
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height*0.7,
        ),
        child: Text.rich(
          TextSpan(
            children: [
              for (var ayah in ayahs) ...[
                // نص الآية
                TextSpan(
                  text: ' ${ayah.text!} ',
                  recognizer: LongPressGestureRecognizer()
                    ..onLongPress = () {
                      print(
                        "لقد ضغطت مطولاً على آية رقم: ${ayah.numberInSurah}",
                      );
                      _showLongPressDialog(context: context, ayahs: ayah);
                    },
                  style: GoogleFonts.amiri(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                    height: 1.8,
                  ),
                ),
                // رقم الآية (هنا بنحط الـ Stack بتاعك جوه النص)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AyahNumber(
                    number: ayah.numberInSurah!,
                    size: 15,
                    volum: 30,
                  ),
                ),
              ],
            ],
          ),
          textAlign: TextAlign.justify, // عشان يخلي السطور متساوية من الجوانب
          textDirection: TextDirection.rtl, // مهم جداً عشان الترتيب من اليمين
        ),
      ),
    );
  }
}

void _showLongPressDialog({
  required BuildContext context,
  required Ayahs ayahs,
}) {
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
