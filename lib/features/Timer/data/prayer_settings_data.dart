import 'package:prayers_times/prayers_times.dart';

const List<String> kPrayerNamesAr = ['الفجر', 'الظهر', 'العصر', 'المغرب', 'العشاء'];
const List<String> kPrayerNamesEn = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

class PrayerMethodOption {
  const PrayerMethodOption(this.key, this.nameAr, this.nameEn, this.parameters);
  final String key;
  final String nameAr;
  final String nameEn;
  final PrayerCalculationParameters Function() parameters;
}

final List<PrayerMethodOption> kPrayerMethods = [
  PrayerMethodOption('egyptian', 'الهيئة المصرية العامة للمساحة',
      'Egyptian General Authority of Survey', PrayerCalculationMethod.egyptian),
  PrayerMethodOption('ummAlQura', 'أم القرى (مكة المكرمة)', 'Umm Al-Qura (Makkah)',
      PrayerCalculationMethod.ummAlQura),
  PrayerMethodOption('muslimWorldLeague', 'رابطة العالم الإسلامي',
      'Muslim World League', PrayerCalculationMethod.muslimWorldLeague),
  PrayerMethodOption('karachi', 'جامعة العلوم الإسلامية بكراتشي',
      'University of Islamic Sciences, Karachi', PrayerCalculationMethod.karachi),
  PrayerMethodOption('northAmerica', 'الجمعية الإسلامية لأمريكا الشمالية',
      'Islamic Society of North America', PrayerCalculationMethod.northAmerica),
  PrayerMethodOption('dubai', 'دبي', 'Dubai', PrayerCalculationMethod.dubai),
  PrayerMethodOption('kuwait', 'الكويت', 'Kuwait', PrayerCalculationMethod.kuwait),
  PrayerMethodOption('qatar', 'قطر', 'Qatar', PrayerCalculationMethod.qatar),
  PrayerMethodOption('turkey', 'رئاسة الشؤون الدينية التركية', 'Diyanet (Turkey)',
      PrayerCalculationMethod.turkey),
];

class PrayerCity {
  const PrayerCity(this.key, this.nameAr, this.nameEn, this.latitude,
      this.longitude, this.timeZone);
  final String key;
  final String nameAr;
  final String nameEn;
  final double latitude;
  final double longitude;
  final String timeZone;
}

/// مدن لتحديد الموقع يدوياً لو الـ GPS مقفول
const List<PrayerCity> kPrayerCities = [
  PrayerCity('cairo', 'القاهرة', 'Cairo', 30.0444, 31.2357, 'Africa/Cairo'),
  PrayerCity('giza', 'الجيزة', 'Giza', 30.0131, 31.2089, 'Africa/Cairo'),
  PrayerCity('alexandria', 'الإسكندرية', 'Alexandria', 31.2001, 29.9187, 'Africa/Cairo'),
  PrayerCity('shebin', 'شبين الكوم', 'Shebin El Kom', 30.5525, 31.0094, 'Africa/Cairo'),
  PrayerCity('tanta', 'طنطا', 'Tanta', 30.7865, 31.0004, 'Africa/Cairo'),
  PrayerCity('mansoura', 'المنصورة', 'Mansoura', 31.0409, 31.3785, 'Africa/Cairo'),
  PrayerCity('zagazig', 'الزقازيق', 'Zagazig', 30.5877, 31.5020, 'Africa/Cairo'),
  PrayerCity('portsaid', 'بورسعيد', 'Port Said', 31.2653, 32.3019, 'Africa/Cairo'),
  PrayerCity('suez', 'السويس', 'Suez', 29.9668, 32.5498, 'Africa/Cairo'),
  PrayerCity('assiut', 'أسيوط', 'Assiut', 27.1783, 31.1859, 'Africa/Cairo'),
  PrayerCity('luxor', 'الأقصر', 'Luxor', 25.6872, 32.6396, 'Africa/Cairo'),
  PrayerCity('aswan', 'أسوان', 'Aswan', 24.0889, 32.8998, 'Africa/Cairo'),
  PrayerCity('makkah', 'مكة المكرمة', 'Makkah', 21.4225, 39.8262, 'Asia/Riyadh'),
  PrayerCity('madinah', 'المدينة المنورة', 'Madinah', 24.4672, 39.6111, 'Asia/Riyadh'),
  PrayerCity('riyadh', 'الرياض', 'Riyadh', 24.7136, 46.6753, 'Asia/Riyadh'),
  PrayerCity('jeddah', 'جدة', 'Jeddah', 21.4858, 39.1925, 'Asia/Riyadh'),
  PrayerCity('dubai', 'دبي', 'Dubai', 25.2048, 55.2708, 'Asia/Dubai'),
  PrayerCity('abudhabi', 'أبوظبي', 'Abu Dhabi', 24.4539, 54.3773, 'Asia/Dubai'),
  PrayerCity('kuwait', 'الكويت', 'Kuwait City', 29.3759, 47.9774, 'Asia/Kuwait'),
  PrayerCity('doha', 'الدوحة', 'Doha', 25.2854, 51.5310, 'Asia/Qatar'),
  PrayerCity('manama', 'المنامة', 'Manama', 26.2285, 50.5860, 'Asia/Bahrain'),
  PrayerCity('muscat', 'مسقط', 'Muscat', 23.5880, 58.3829, 'Asia/Muscat'),
  PrayerCity('amman', 'عمّان', 'Amman', 31.9454, 35.9284, 'Asia/Amman'),
  PrayerCity('jerusalem', 'القدس', 'Jerusalem', 31.7683, 35.2137, 'Asia/Jerusalem'),
  PrayerCity('beirut', 'بيروت', 'Beirut', 33.8938, 35.5018, 'Asia/Beirut'),
  PrayerCity('damascus', 'دمشق', 'Damascus', 33.5138, 36.2765, 'Asia/Damascus'),
  PrayerCity('baghdad', 'بغداد', 'Baghdad', 33.3152, 44.3661, 'Asia/Baghdad'),
  PrayerCity('khartoum', 'الخرطوم', 'Khartoum', 15.5007, 32.5599, 'Africa/Khartoum'),
  PrayerCity('tripoli', 'طرابلس', 'Tripoli', 32.8872, 13.1913, 'Africa/Tripoli'),
  PrayerCity('tunis', 'تونس', 'Tunis', 36.8065, 10.1815, 'Africa/Tunis'),
  PrayerCity('algiers', 'الجزائر', 'Algiers', 36.7538, 3.0588, 'Africa/Algiers'),
  PrayerCity('casablanca', 'الدار البيضاء', 'Casablanca', 33.5731, -7.5898, 'Africa/Casablanca'),
  PrayerCity('istanbul', 'إسطنبول', 'Istanbul', 41.0082, 28.9784, 'Europe/Istanbul'),
  PrayerCity('london', 'لندن', 'London', 51.5074, -0.1278, 'Europe/London'),
  PrayerCity('newyork', 'نيويورك', 'New York', 40.7128, -74.0060, 'America/New_York'),
];
