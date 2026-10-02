import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Hadith/data/hadith_models.dart';
import 'package:islami/features/Hadith/data/hadith_repo.dart';

class HadithCard extends StatefulWidget {
  const HadithCard({super.key, required this.hadith, this.showBookName = false});
  final Hadith hadith;
  final bool showBookName;

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard> {
  final _repo = HadithRepo.instance;
  bool _favorite = false;

  @override
  void initState() {
    super.initState();
    _repo.isFavorite(widget.hadith).then((value) {
      if (mounted) setState(() => _favorite = value);
    });
  }

  String get _title {
    final number = 'الحديث ${widget.hadith.number}';
    if (!widget.showBookName) return number;
    return '${_repo.bookByKey(widget.hadith.bookKey).name} • $number';
  }

  Future<void> _toggleFavorite() async {
    final added = await _repo.toggleFavorite(widget.hadith);
    if (!mounted) return;
    setState(() => _favorite = added);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(added ? 'تمت الإضافة للمفضلة' : 'تمت الإزالة من المفضلة'),
      duration: const Duration(seconds: 2),
    ));
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: '${widget.hadith.text}\n[$_title]'));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الحديث'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.primaryColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _title,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _copy,
                tooltip: 'نسخ',
                icon: const Icon(Icons.copy_rounded, color: Colors.white54),
              ),
              IconButton(
                onPressed: _toggleFavorite,
                tooltip: _favorite ? 'إزالة من المفضلة' : 'إضافة للمفضلة',
                icon: Icon(
                  _favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          Text(
            widget.hadith.text,
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontSize: 18.sp,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
