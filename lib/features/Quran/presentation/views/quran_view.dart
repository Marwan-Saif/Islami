import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:islami/core/helper_functions/app_router.dart';
import 'package:islami/core/services/get_it.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/core/utils/app_images.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Quran/presentation/manager/quran_cubit/quran_cubit.dart';
import 'package:islami/features/Quran/presentation/views/widgets/reading_tracker_card.dart';
import 'package:islami/features/Quran/presentation/views/widgets/search_textfield.dart';
import 'package:islami/features/Quran/presentation/views/widgets/sura_list.dart';
import 'package:islami/generated/l10n.dart';

class QuranView extends StatefulWidget {
  const QuranView({
    super.key,
  });

  @override
  State<QuranView> createState() => _QuranViewState();
}

class _QuranViewState extends State<QuranView> {
  String _query = '';

  // البحث في الآيات محتاج كلمة حقيقية مش رقم سورة
  bool get _canSearchAyahs =>
      int.tryParse(_query.trim()) == null &&
      QuranCubit.normalizeArabic(_query).length >= 2;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuranCubit(getit.get<QuranRepo>())..getQuran(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.sp),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsetsDirectional.symmetric(horizontal: 60.sp),
            child: Image.asset(
              Assets.imagesMosque001,
              width: 200.sp,
            ),
          ),
          //*****Screen */
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: [
                const ReadingTrackerCard(),
                Builder(
                  builder: (context) => SearchTextField(
                    hintText: 'ابحث عن سورة أو آية',
                    onChanged: (query) {
                      setState(() => _query = query);
                      context.read<QuranCubit>().search(query);
                    },
                  ),
                ),
                if (_canSearchAyahs)
                  _AyahSearchTile(
                    query: _query,
                    onTap: () => context.push(AppRouter.ayahSearchView,
                        extra: _query.trim()),
                  ),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      S.of(context).Suras_List,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold),
                    )),
                const SurasList()
              ]),
            ),
          )
        ],
      ),
    );
  }
}

class _AyahSearchTile extends StatelessWidget {
  const _AyahSearchTile({required this.query, required this.onTap});
  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.manage_search_rounded,
          color: AppColors.primaryColor),
      title: Text(
        'ابحث في الآيات عن «${query.trim()}»',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppColors.primaryColor, fontSize: 15.sp),
      ),
    );
  }
}
