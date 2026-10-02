import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/settings/presentation/views/widgets/settings_widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  // بيشتغل بعد ما التطبيق يتنشر على Google Play بالـ ID ده
  static const String _storeUrl =
      'https://play.google.com/store/apps/details?id=com.marwansaif.islami';

  Future<void> _rate(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(_storeUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تعذر فتح المتجر')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: 'عن التطبيق',
      icon: Icons.info_outline_rounded,
      children: [
        SettingsTile(
          title: 'مشاركة التطبيق',
          value: null,
          icon: Icons.share_rounded,
          onTap: () => SharePlus.instance.share(
            ShareParams(
              text:
                  'تطبيق إسلامي: القرآن الكريم ومواقيت الصلاة والأذكار والأحاديث\n$_storeUrl',
            ),
          ),
        ),
        SettingsTile(
          title: 'قيّم التطبيق',
          value: null,
          icon: Icons.star_rate_rounded,
          onTap: () => _rate(context),
        ),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              snapshot.hasData
                  ? 'الإصدار ${snapshot.data!.version} (${snapshot.data!.buildNumber})'
                  : '',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 13.sp),
            ),
          ),
        ),
      ],
    );
  }
}
