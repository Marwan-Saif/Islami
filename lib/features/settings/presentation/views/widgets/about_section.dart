import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islami/core/utils/app_colors.dart';
import 'package:islami/features/settings/presentation/views/widgets/settings_widgets.dart';
import 'package:islami/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  // بيشتغل بعد ما التطبيق يتنشر على Google Play بالـ ID ده
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.marwansaif.athar';

  // نفس اللينك اللي بيتحط في Google Play Console
  static const String _privacyPolicyUrl =
      'https://github.com/Marwan-Saif/Islami/blob/main/docs/privacy-policy.md';

  // حساب المطوّر
  static const String _linkedInUrl = 'https://www.linkedin.com/in/marwan-saif';
  static const String _contactEmail = 'marwansaif09@gmail.com';

  // رقم التطبيق على App Store (بيظهر بعد إنشائه على App Store Connect)،
  // ولحد ما يتحط زرار التقييم مش بيظهر على الآيفون
  static const String _appStoreId = '';

  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static String? get _storeUrl {
    if (!_isIOS) return _playStoreUrl;
    if (_appStoreId.isEmpty) return null;
    return 'https://apps.apple.com/app/id$_appStoreId';
  }

  Future<void> _rate(BuildContext context) async {
    final opened = await launchUrl(
      Uri.parse(_storeUrl!),
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.of(context).storeOpenFailed)));
    }
  }

  // بيفتح برنامج الإيميل برسالة عنوانها اسم التطبيق، ولو مفيش برنامج إيميل
  // بينسخ العنوان ويقول للمستخدم
  Future<void> _openEmail(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: _contactEmail,
      query: 'subject=${Uri.encodeComponent(S.of(context).appName)}',
    );
    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    ).catchError((_) => false);
    if (opened || !context.mounted) return;
    await Clipboard.setData(const ClipboardData(text: _contactEmail));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(S.of(context).emailCopied)));
  }

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: S.of(context).aboutApp,
      icon: Icons.info_outline_rounded,
      children: [
        SettingsTile(
          title: S.of(context).shareApp,
          value: null,
          icon: Icons.share_rounded,
          onTap: () => SharePlus.instance.share(
            ShareParams(
              text: S.of(context).shareAppText(_storeUrl ?? _playStoreUrl),
            ),
          ),
        ),
        if (_storeUrl != null)
          SettingsTile(
            title: S.of(context).rateApp,
            value: null,
            icon: Icons.star_rate_rounded,
            onTap: () => _rate(context),
          ),
        SettingsTile(
          title: S.of(context).contactUs,
          value: _contactEmail,
          icon: Icons.mail_outline_rounded,
          onTap: () => _openEmail(context),
        ),
        SettingsTile(
          title: 'LinkedIn',
          value: S.of(context).developedBy,
          icon: Icons.person_rounded,
          onTap: () => launchUrl(
            Uri.parse(_linkedInUrl),
            mode: LaunchMode.externalApplication,
          ),
        ),
        SettingsTile(
          title: S.of(context).privacyPolicy,
          value: null,
          icon: Icons.privacy_tip_outlined,
          onTap: () => launchUrl(
            Uri.parse(_privacyPolicyUrl),
            mode: LaunchMode.externalApplication,
          ),
        ),
        SettingsTile(
          title: S.of(context).licensesAndSources,
          value: null,
          icon: Icons.description_outlined,
          onTap: () => showLicensePage(
            context: context,
            applicationName: S.of(context).appName,
            applicationLegalese: S.of(context).developedBy,
          ),
        ),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) => Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              // اسم المطوّر ورقم الإصدار في آخر الإعدادات
              snapshot.hasData
                  ? '${S.of(context).developedBy}\n${S.of(context).appVersion(snapshot.data!.version, snapshot.data!.buildNumber)}'
                  : S.of(context).developedBy,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.primaryColor, fontSize: 13.sp),
            ),
          ),
        ),
      ],
    );
  }
}
