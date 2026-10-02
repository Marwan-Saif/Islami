import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/Quran/presentation/views/widgets/search_textfield.dart';
import 'package:islami/features/Radio/data/models/reciter_model.dart';
import 'package:islami/features/Radio/domain/recitations_repo.dart';
import 'package:islami/features/Radio/presentation/manager/reciters_cubit/reciters_cubit.dart';
import 'package:islami/features/Radio/presentation/views/widgets/recitation_scaffold.dart';

class RecitersView extends StatelessWidget {
  const RecitersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RecitersCubit(getit.get<RecitationsRepo>())..getReciters(),
      child: RecitationScaffold(
        title: 'اختيار القارئ',
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              Builder(
                builder: (context) => SearchTextField(
                  hintText: 'ابحث عن قارئ',
                  onChanged: context.read<RecitersCubit>().search,
                ),
              ),
              SizedBox(height: 12.h),
              const Expanded(child: RecitersListBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class RecitersListBody extends StatelessWidget {
  const RecitersListBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecitersCubit, RecitersState>(
      builder: (context, state) {
        if (state is RecitersFailure) {
          return _ErrorView(
            message: state.errorMessage,
            onRetry: context.read<RecitersCubit>().getReciters,
          );
        }
        if (state is! RecitersSuccess) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          );
        }
        if (state.reciters.isEmpty) {
          return Center(
            child: Text(
              'لا يوجد قارئ بهذا الاسم',
              style: TextStyle(color: Colors.white70, fontSize: 16.sp),
            ),
          );
        }
        return ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: state.reciters.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) =>
              ReciterCard(reciter: state.reciters[index]),
        );
      },
    );
  }
}

class ReciterCard extends StatelessWidget {
  const ReciterCard({super.key, required this.reciter});
  final ReciterModel reciter;

  @override
  Widget build(BuildContext context) {
    final rewayat = reciter.moshaf.length;
    return InkWell(
      onTap: () => _openReciter(context),
      borderRadius: BorderRadius.circular(20.r),
      splashColor: AppColors.primaryColor.withValues(alpha: 0.2),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(Icons.record_voice_over_rounded,
                  color: AppColors.primaryColor, size: 26.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reciter.name,
                    style: GoogleFonts.amiri(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    rewayat == 1
                        ? reciter.moshaf.first.name
                        : '$rewayat روايات',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white54, fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white38, size: 18.r),
          ],
        ),
      ),
    );
  }

  Future<void> _openReciter(BuildContext context) async {
    MoshafModel? moshaf = reciter.moshaf.length == 1
        ? reciter.moshaf.first
        : await _pickMoshaf(context);
    if (moshaf == null || !context.mounted) return;
    await getit.get<RecitationsRepo>().saveLastSelection(reciter, moshaf);
    if (!context.mounted) return;
    context.push(
      AppRouter.reciterSurahsView,
      extra: (reciter: reciter, moshaf: moshaf),
    );
  }

  Future<MoshafModel?> _pickMoshaf(BuildContext context) {
    return showModalBottomSheet<MoshafModel>(
      context: context,
      backgroundColor: AppColors.backgroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        side: const BorderSide(color: AppColors.primaryColor, width: 1.5),
      ),
      builder: (context) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.h),
              Text(
                'اختر الرواية',
                style: GoogleFonts.amiri(
                  color: AppColors.primaryColor,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  children: [
                    for (var moshaf in reciter.moshaf)
                      ListTile(
                        onTap: () => Navigator.of(context).pop(moshaf),
                        leading: const Icon(Icons.menu_book_rounded,
                            color: AppColors.primaryColor),
                        title: Text(
                          moshaf.name,
                          style: TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                        subtitle: Text(
                          '${moshaf.surahList.length} سورة',
                          style: TextStyle(color: Colors.white54, fontSize: 12.sp),
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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.primaryColor, size: 48.r),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15.sp),
          ),
          SizedBox(height: 16.h),
          OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              side: const BorderSide(color: AppColors.primaryColor),
            ),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
