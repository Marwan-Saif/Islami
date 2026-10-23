import 'package:flutter/material.dart';

/// ألوان أثر للوضعين الفاتح والداكن.
///
/// الألوان getters بتقرا [brightness] اللي بيتحدد في main مع كل تغيير
/// للثيم، والتطبيق كله بيتبني من جديد وقتها (KeyedSubtree في MainApp)،
/// فكل ويدجت بتاخد ألوان الوضع الجديد من غير ما تحتاج Theme.of(context).
abstract class AppColors {
  static Brightness brightness = Brightness.dark;
  static bool get isDark => brightness == Brightness.dark;

  static Color _pick(int dark, int light) => Color(isDark ? dark : light);

  // ---------- الهوية ----------
  /// دهبي نور الفانوس. في الفاتح أغمق عشان يتقري على الخلفية الفاتحة
  static Color get primaryColor => _pick(0xFFE5BA6A, 0xFF8F6114);

  /// لون أفتح من الدهبي للتوهج والتدرجات
  static Color get glow => _pick(0xFFF6D28E, 0xFFD9A441);

  /// الخلفية: كحلي الليل في الداكن، وورق دافي في الفاتح
  static Color get backgroundColor => _pick(0xFF0D1720, 0xFFF7F1E6);

  /// لون تاني للخلفية عشان التدرج
  static Color get backgroundDeep => _pick(0xFF091018, 0xFFEFE5D2);

  // ---------- الأسطح ----------
  /// الكروت والقوائم
  static Color get surface => _pick(0xFF15222E, 0xFFFFFFFF);

  /// سطح أعلى (الشيتات، الشريط السفلي)
  static Color get surfaceHigh => _pick(0xFF1C2C3A, 0xFFFBF6EC);

  /// كروت شبه شفافة فوق الزخرفة
  static Color get card => isDark
      ? const Color(0xFF15222E).withValues(alpha: 0.85)
      : Colors.white.withValues(alpha: 0.88);

  // ---------- النصوص ----------
  static Color get text => _pick(0xFFF4EDE1, 0xFF1A2530);
  static Color get textMuted => text.withValues(alpha: 0.72);
  // الفاتح محتاج نسبة أعلى عشان التباين يفضل فوق 4.5:1 على الخلفية الفاتحة
  static Color get textFaint => text.withValues(alpha: isDark ? 0.55 : 0.68);
  static Color get divider => text.withValues(alpha: 0.12);

  /// النص فوق الدهبي
  static Color get onPrimary => _pick(0xFF0D1720, 0xFFFFFFFF);

  static Color get danger => _pick(0xFFFF8A80, 0xFFC62828);
  static Color get warning => _pick(0xFFFFB74D, 0xFFB45309);

  /// متبقي من الكود القديم (كان أبيض ثابت)
  static Color get secondaryColor => text;

  /// تدرج الخلفية العام
  static LinearGradient get backgroundGradient => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, backgroundDeep],
  );

  /// تدرج الكروت الدهبي (كارت المواقيت والأزرار المميزة)
  static LinearGradient get goldGradient => LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: isDark
        ? const [Color(0xFFF0CB82), Color(0xFFC9963F)]
        // أغمق في الفاتح عشان النص الأبيض فوقه يعدّي 4.5:1
        : const [Color(0xFF96661A), Color(0xFF74490C)],
  );
}
