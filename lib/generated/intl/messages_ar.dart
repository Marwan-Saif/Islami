// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ar';

  static String m0(version, build) => "الإصدار ${version} (${build})";

  static String m1(count) =>
      "${Intl.plural(count, one: 'آية واحدة', two: 'آيتان', few: '${count} آيات', other: '${count} آية')}";

  static String m2(surah, ayah) => "${surah} - آية ${ayah}";

  static String m3(surah, ayah) => "${surah} • آية ${ayah}";

  static String m4(count) => "الختمات المكتملة: ${count}";

  static String m5(city) => "${city} (افتراضي)";

  static String m6(number) => "الحديث ${number}";

  static String m7(first, last) => "الأحاديث ${first} - ${last}";

  static String m8(days) => "ختمة كل ${days} يوم تقريباً";

  static String m9(position) => "آخر قراءة: ${position}";

  static String m10(count) => "${count} دقيقة";

  static String m11(name, time) => "الصلاة القادمة: ${name} - ${time}";

  static String m12(query) => "لا توجد آيات تحتوي على «${query}»";

  static String m13(time) => "الوقت المحدد لإرسال الإشعارات: ${time}";

  static String m14(page, juz) => "صفحة ${page} • الجزء ${juz}";

  static String m15(page) => "صفحة ${page}";

  static String m16(count) =>
      "${Intl.plural(count, one: 'صفحة واحدة', two: 'صفحتان', few: '${count} صفحات', other: '${count} صفحة')}";

  static String m17(name) => "صلاة ${name}";

  static String m18(read, total) => "قرأت ${read} من ${total} صفحة";

  static String m19(name) => "القارئ: ${name}";

  static String m20(count) => "${count} روايات";

  static String m21(query) => "ابحث في الآيات عن «${query}»";

  static String m22(query) => "نتائج «${query}»";

  static String m23(url) =>
      "تطبيق إسلامي: القرآن الكريم ومواقيت الصلاة والأذكار والأحاديث\n${url}";

  static String m24(count) => "أيام متتالية: ${count}";

  static String m25(count) => " • ${count} أيام متتالية";

  static String m26(count) => "${count} سورة";

  static String m27(name) => "السور بصوت ${name}";

  static String m28(city) => "المواقيت حسب ${city} - اضغط لاستخدام موقعك";

  static String m29(today, goal) => "اليوم ${today} من ${goal} صفحات";

  static String m30(today, goal) => "ورد اليوم ${today}/${goal} صفحات";

  static String m31(count) => "الإجمالي: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "Enter_text_here":
            MessageLookupByLibrary.simpleMessage("أدخل النص هنا"),
        "Suras_List": MessageLookupByLibrary.simpleMessage("قائمة السور"),
        "Verse": MessageLookupByLibrary.simpleMessage("عدد الآيات"),
        "aboutApp": MessageLookupByLibrary.simpleMessage("عن التطبيق"),
        "addBookmark": MessageLookupByLibrary.simpleMessage("إضافة علامة"),
        "addToFavorites": MessageLookupByLibrary.simpleMessage("إضافة للمفضلة"),
        "addedToFavorites":
            MessageLookupByLibrary.simpleMessage("تمت الإضافة للمفضلة"),
        "adhanFull": MessageLookupByLibrary.simpleMessage("الأذان كاملاً"),
        "adhanPerPrayer":
            MessageLookupByLibrary.simpleMessage("الأذان لكل صلاة"),
        "adhanShort":
            MessageLookupByLibrary.simpleMessage("أذان مختصر (أول 30 ثانية)"),
        "adhanSilent": MessageLookupByLibrary.simpleMessage("صامت (إشعار فقط)"),
        "adhanSound": MessageLookupByLibrary.simpleMessage("صوت الأذان"),
        "adhanTone": MessageLookupByLibrary.simpleMessage("تنبيه قصير"),
        "adhanTurnedOff":
            MessageLookupByLibrary.simpleMessage("تم إيقاف الأذان"),
        "adhanTurnedOn":
            MessageLookupByLibrary.simpleMessage("تم تفعيل الأذان"),
        "allowLocation": MessageLookupByLibrary.simpleMessage("السماح بالموقع"),
        "appSubtitle": MessageLookupByLibrary.simpleMessage("تطبيق إسلامي"),
        "appVersion": m0,
        "asr": MessageLookupByLibrary.simpleMessage("العصر"),
        "asrHanafi": MessageLookupByLibrary.simpleMessage("العصر: حنفي"),
        "asrShafi": MessageLookupByLibrary.simpleMessage("العصر: شافعي"),
        "audioLibrary": MessageLookupByLibrary.simpleMessage("المكتبة الصوتية"),
        "ayahCopied": MessageLookupByLibrary.simpleMessage("تم نسخ الآية"),
        "ayahCount": m1,
        "ayahRef": m2,
        "ayahRefDot": m3,
        "azkar": MessageLookupByLibrary.simpleMessage("الأذكار"),
        "azkarAfterPrayer":
            MessageLookupByLibrary.simpleMessage("أذكار بعد الصلاة"),
        "azkarEvening": MessageLookupByLibrary.simpleMessage("أذكار المساء"),
        "azkarFood": MessageLookupByLibrary.simpleMessage("أذكار الطعام"),
        "azkarMorning": MessageLookupByLibrary.simpleMessage("أذكار الصباح"),
        "azkarMosque": MessageLookupByLibrary.simpleMessage("أذكار المسجد"),
        "azkarPrayer": MessageLookupByLibrary.simpleMessage("أذكار الصلاة"),
        "azkarSleep": MessageLookupByLibrary.simpleMessage("أذكار النوم"),
        "azkarWakingUp":
            MessageLookupByLibrary.simpleMessage("أذكار الاستيقاظ"),
        "back": MessageLookupByLibrary.simpleMessage("رجوع"),
        "bookmarkAdded":
            MessageLookupByLibrary.simpleMessage("تمت إضافة العلامة"),
        "bookmarkRemoved":
            MessageLookupByLibrary.simpleMessage("تمت إزالة العلامة"),
        "bookmarks": MessageLookupByLibrary.simpleMessage("العلامات"),
        "bookmarksEmpty": MessageLookupByLibrary.simpleMessage(
            "اضغط مطولاً على أي آية واختار \"إضافة علامة\""),
        "calculationMethod":
            MessageLookupByLibrary.simpleMessage("طريقة الحساب"),
        "cancel": MessageLookupByLibrary.simpleMessage("إلغاء"),
        "changeReciter": MessageLookupByLibrary.simpleMessage("تغيير القارئ"),
        "chooseRecitation":
            MessageLookupByLibrary.simpleMessage("اختيار التلاوة"),
        "chooseReciter": MessageLookupByLibrary.simpleMessage("اختيار القارئ"),
        "chooseReciterSubtitle":
            MessageLookupByLibrary.simpleMessage("اختر شيخك المفضل للاستماع"),
        "chooseRewaya": MessageLookupByLibrary.simpleMessage("اختر الرواية"),
        "clear": MessageLookupByLibrary.simpleMessage("تنظيف"),
        "close": MessageLookupByLibrary.simpleMessage("إغلاق"),
        "completedKhatmas": m4,
        "continueReading": MessageLookupByLibrary.simpleMessage("أكمل"),
        "copy": MessageLookupByLibrary.simpleMessage("نسخ"),
        "copyAyah": MessageLookupByLibrary.simpleMessage("نسخ الآية"),
        "dailyWird": MessageLookupByLibrary.simpleMessage("الورد اليومي"),
        "defaultAyahReciter":
            MessageLookupByLibrary.simpleMessage("القارئ الافتراضي للآيات"),
        "defaultCity": m5,
        "defaultCityName": MessageLookupByLibrary.simpleMessage("المنوفية"),
        "deleteBookmark": MessageLookupByLibrary.simpleMessage("حذف العلامة"),
        "dhuhr": MessageLookupByLibrary.simpleMessage("الظهر"),
        "disableAdhan": MessageLookupByLibrary.simpleMessage("إيقاف الأذان"),
        "editGoal": MessageLookupByLibrary.simpleMessage("تعديل الهدف"),
        "enableAdhan": MessageLookupByLibrary.simpleMessage("تفعيل الأذان"),
        "enableLocationForTimes": MessageLookupByLibrary.simpleMessage(
            "فعّل الموقع واسمح للتطبيق بالوصول إليه لتحديث المواقيت"),
        "enableLocationHint": MessageLookupByLibrary.simpleMessage(
            "فعّل الموقع واسمح للتطبيق بالوصول إليه"),
        "enableNotifications":
            MessageLookupByLibrary.simpleMessage("تفعيل الإشعارات"),
        "fajr": MessageLookupByLibrary.simpleMessage("الفجر"),
        "favoriteHadiths":
            MessageLookupByLibrary.simpleMessage("الأحاديث المفضلة"),
        "favorites": MessageLookupByLibrary.simpleMessage("المفضلة"),
        "favoritesEmpty": MessageLookupByLibrary.simpleMessage(
            "اضغط على ♡ في أي حديث لإضافته هنا"),
        "finish": MessageLookupByLibrary.simpleMessage("إنهاء"),
        "fullJuz": MessageLookupByLibrary.simpleMessage("جزء كامل (20 صفحة)"),
        "hadithCopied": MessageLookupByLibrary.simpleMessage("تم نسخ الحديث"),
        "hadithLoadError": MessageLookupByLibrary.simpleMessage(
            "تعذر تحميل الأحاديث، تأكد من الاتصال بالإنترنت"),
        "hadithNumber": m6,
        "hadithRange": m7,
        "hadiths": MessageLookupByLibrary.simpleMessage("الأحاديث"),
        "hideTafsir": MessageLookupByLibrary.simpleMessage("إخفاء التفسير"),
        "history": MessageLookupByLibrary.simpleMessage("السجل السابق"),
        "isha": MessageLookupByLibrary.simpleMessage("العشاء"),
        "khatma": MessageLookupByLibrary.simpleMessage("الختمة"),
        "khatmaCompletedMessage": MessageLookupByLibrary.simpleMessage(
            "مبارك! أتممت ختمة كاملة للقرآن الكريم"),
        "khatmaEveryDays": m8,
        "language": MessageLookupByLibrary.simpleMessage("اللغة"),
        "lastRead": MessageLookupByLibrary.simpleMessage("آخر قراءة"),
        "lastReadAt": m9,
        "listen": MessageLookupByLibrary.simpleMessage("استماع"),
        "listenToAyah": MessageLookupByLibrary.simpleMessage("استماع للآية"),
        "liveBroadcast": MessageLookupByLibrary.simpleMessage("بث مباشر"),
        "location": MessageLookupByLibrary.simpleMessage("الموقع"),
        "locationDeniedForever": MessageLookupByLibrary.simpleMessage(
            "إذن الموقع مرفوض، فعّله من إعدادات التطبيق"),
        "locationFailed": MessageLookupByLibrary.simpleMessage(
            "تعذر تحديد موقعك، حاول مرة أخرى"),
        "locationNeededForQibla": MessageLookupByLibrary.simpleMessage(
            "نحتاج إذن الموقع لحساب اتجاه القبلة من مكانك"),
        "maghrib": MessageLookupByLibrary.simpleMessage("المغرب"),
        "meccan": MessageLookupByLibrary.simpleMessage("مكية"),
        "medinan": MessageLookupByLibrary.simpleMessage("مدنية"),
        "minutesCount": m10,
        "myLocation":
            MessageLookupByLibrary.simpleMessage("موقعي الحالي (GPS)"),
        "navHome": MessageLookupByLibrary.simpleMessage("الرئيسية"),
        "navQibla": MessageLookupByLibrary.simpleMessage("القبلة"),
        "navQuran": MessageLookupByLibrary.simpleMessage("القرآن"),
        "navRadio": MessageLookupByLibrary.simpleMessage("الراديو"),
        "navTasbih": MessageLookupByLibrary.simpleMessage("السبحة"),
        "next": MessageLookupByLibrary.simpleMessage("التالي"),
        "nextPrayer": m11,
        "noAyahsFor": m12,
        "noCompassSensor": MessageLookupByLibrary.simpleMessage(
            "جهازك لا يحتوي على حساس البوصلة"),
        "noInternetHint":
            MessageLookupByLibrary.simpleMessage("تأكد من الاتصال بالإنترنت"),
        "noReciterFound":
            MessageLookupByLibrary.simpleMessage("لا يوجد قارئ بهذا الاسم"),
        "noSurahFound":
            MessageLookupByLibrary.simpleMessage("لا توجد سورة بهذا الاسم"),
        "notificationTime": m13,
        "off": MessageLookupByLibrary.simpleMessage("بدون"),
        "onboarding1_body": MessageLookupByLibrary.simpleMessage(
            "نحن متحمسون جدًا لانضمامك إلى مجتمعنا"),
        "onboarding1_title":
            MessageLookupByLibrary.simpleMessage("مرحبًا بك في إسلامي"),
        "onboarding2_body":
            MessageLookupByLibrary.simpleMessage("اقرأ وربك الأكرم"),
        "onboarding2_title":
            MessageLookupByLibrary.simpleMessage("قراءة القرآن"),
        "onboarding3_body":
            MessageLookupByLibrary.simpleMessage("سبح اسم ربك الأعلى"),
        "onboarding3_title": MessageLookupByLibrary.simpleMessage("سبح"),
        "onboarding4_body": MessageLookupByLibrary.simpleMessage(
            "يمكنك الاستماع إلى إذاعة القرآن الكريم من خلال التطبيق مجانًا وبسهولة"),
        "onboarding4_title":
            MessageLookupByLibrary.simpleMessage("إذاعة القرآن الكريم"),
        "openSettings": MessageLookupByLibrary.simpleMessage("فتح الإعدادات"),
        "pageAndJuz": m14,
        "pageNumber": m15,
        "pagesCount": m16,
        "pause": MessageLookupByLibrary.simpleMessage("إيقاف مؤقت"),
        "play": MessageLookupByLibrary.simpleMessage("تشغيل"),
        "playAll": MessageLookupByLibrary.simpleMessage("تشغيل الكل"),
        "playFromHere":
            MessageLookupByLibrary.simpleMessage("تشغيل من هنا لآخر السورة"),
        "prayerCalculationMethod":
            MessageLookupByLibrary.simpleMessage("طريقة حساب المواقيت"),
        "prayerName": m17,
        "prayerTimes": MessageLookupByLibrary.simpleMessage("مواقيت الصلاة"),
        "previous": MessageLookupByLibrary.simpleMessage("السابق"),
        "qiblaDirection": MessageLookupByLibrary.simpleMessage("اتجاه القبلة"),
        "quranFontSize": MessageLookupByLibrary.simpleMessage("حجم خط المصحف"),
        "radioAbdulbari":
            MessageLookupByLibrary.simpleMessage("إذاعة عبد الباري محمد"),
        "radioAndRecitations":
            MessageLookupByLibrary.simpleMessage("الراديو والتلاوات"),
        "radioBasfar":
            MessageLookupByLibrary.simpleMessage("إذاعة عبد الله بصفر"),
        "radioKhayat":
            MessageLookupByLibrary.simpleMessage("إذاعة عبد الله خياط"),
        "rateApp": MessageLookupByLibrary.simpleMessage("قيّم التطبيق"),
        "readPagesOf": m18,
        "reading": MessageLookupByLibrary.simpleMessage("القراءة"),
        "readingTracker":
            MessageLookupByLibrary.simpleMessage("متابعة التلاوة"),
        "recitations": MessageLookupByLibrary.simpleMessage("التلاوات"),
        "reciterLabel": m19,
        "recitersLoadError": MessageLookupByLibrary.simpleMessage(
            "تعذر تحميل قائمة القراء، تأكد من الاتصال بالإنترنت"),
        "reminderBeforePrayer":
            MessageLookupByLibrary.simpleMessage("تذكير قبل الصلاة"),
        "removeBookmark": MessageLookupByLibrary.simpleMessage("إزالة العلامة"),
        "removeFromFavorites":
            MessageLookupByLibrary.simpleMessage("إزالة من المفضلة"),
        "removedFromFavorites":
            MessageLookupByLibrary.simpleMessage("تمت الإزالة من المفضلة"),
        "resetKhatmaConfirm": MessageLookupByLibrary.simpleMessage(
            "سيتم تصفير تقدم الختمة الحالية، هل أنت متأكد؟"),
        "retry": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
        "rewayatCount": m20,
        "rotateDeviceForQibla": MessageLookupByLibrary.simpleMessage(
            "أدر الجهاز لتحديد اتجاه القبلة"),
        "searchAyahsFor": m21,
        "searchReciter": MessageLookupByLibrary.simpleMessage("ابحث عن قارئ"),
        "searchResultsFor": m22,
        "searchSurahOrAyah":
            MessageLookupByLibrary.simpleMessage("ابحث عن سورة أو آية"),
        "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
        "shareApp": MessageLookupByLibrary.simpleMessage("مشاركة التطبيق"),
        "shareAppText": m23,
        "showEnglishTranslation":
            MessageLookupByLibrary.simpleMessage("إظهار الترجمة الإنجليزية"),
        "skip": MessageLookupByLibrary.simpleMessage("تخطي"),
        "start": MessageLookupByLibrary.simpleMessage("ابدأ"),
        "startKhatmaHint":
            MessageLookupByLibrary.simpleMessage("ابدأ ختمتك من سورة الفاتحة"),
        "startNewKhatma":
            MessageLookupByLibrary.simpleMessage("بدء ختمة جديدة"),
        "startOver": MessageLookupByLibrary.simpleMessage("ابدأ من جديد"),
        "storeOpenFailed":
            MessageLookupByLibrary.simpleMessage("تعذر فتح المتجر"),
        "streakDays": m24,
        "streakSuffix": m25,
        "sunrise": MessageLookupByLibrary.simpleMessage("الشروق"),
        "surahCount": m26,
        "surahPrefix": MessageLookupByLibrary.simpleMessage("سورة"),
        "surahsByReciter": m27,
        "tafsirMuyassar":
            MessageLookupByLibrary.simpleMessage("التفسير الميسر"),
        "tafsirUnavailable":
            MessageLookupByLibrary.simpleMessage("التفسير غير متاح لهذه الآية"),
        "timesForCity": m28,
        "timesForMyLocation": MessageLookupByLibrary.simpleMessage(
            "المواقيت حسب موقعك - اضغط للتحديث"),
        "timesUpdatedForLocation":
            MessageLookupByLibrary.simpleMessage("تم تحديث المواقيت حسب موقعك"),
        "todayPagesOf": m29,
        "todayWird": m30,
        "total": m31,
        "totalLabel": MessageLookupByLibrary.simpleMessage("الإجمالي:"),
        "turnOnGpsForQibla": MessageLookupByLibrary.simpleMessage(
            "شغّل خدمة الموقع (GPS) لتحديد اتجاه القبلة"),
        "useMyLocation":
            MessageLookupByLibrary.simpleMessage("استخدام موقعي الحالي (GPS)")
      };
}
