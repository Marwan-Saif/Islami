import 'package:islami/core/services/app_settings.dart';
import 'package:quran_with_tafsir/quran_with_tafsir.dart';

/// قارئ لسماع آية معينة (ملفات everyayah.com اللي باكدج quran_with_tafsir بتستخدمها)
class AyahReciter {
  const AyahReciter(this.id, this.nameAr, this.nameEn);
  final String id;
  final String nameAr;
  final String nameEn;

  String get name => AppSettings.instance.isArabic ? nameAr : nameEn;

  String ayahUrl(int surah, int ayah) =>
      QuranService.instance.getAudioUrl(surah, ayah, reciterIdentifier: id);
}

const List<AyahReciter> kAyahReciters = [
  AyahReciter(Reciters.alafasy, 'مشاري العفاسي', 'Mishary Alafasy'),
  AyahReciter(
    Reciters.abdulBasit,
    'عبد الباسط عبد الصمد (مرتل)',
    'Abdul Basit Abdul Samad (Murattal)',
  ),
  AyahReciter(
    Reciters.abdulBasitMujawwad,
    'عبد الباسط عبد الصمد (مجود)',
    'Abdul Basit Abdul Samad (Mujawwad)',
  ),
  AyahReciter(Reciters.husary, 'محمود خليل الحصري', 'Mahmoud Khalil Al-Husary'),
  AyahReciter(
    Reciters.husaryMujawwad,
    'محمود خليل الحصري (مجود)',
    'Mahmoud Khalil Al-Husary (Mujawwad)',
  ),
  AyahReciter(
    'Husary_Muallim_128kbps',
    'محمود خليل الحصري (المعلم)',
    'Mahmoud Khalil Al-Husary (Muallim)',
  ),
  AyahReciter(
    Reciters.minshawi,
    'محمد صديق المنشاوي (مرتل)',
    'Mohamed Siddiq Al-Minshawi (Murattal)',
  ),
  AyahReciter(
    Reciters.minshawiMujawwad,
    'محمد صديق المنشاوي (مجود)',
    'Mohamed Siddiq Al-Minshawi (Mujawwad)',
  ),
  AyahReciter('Mustafa_Ismail_48kbps', 'مصطفى إسماعيل', 'Mustafa Ismail'),
  AyahReciter('Muhammad_Jibreel_128kbps', 'محمد جبريل', 'Muhammad Jibreel'),
  AyahReciter(Reciters.maherMuaiqly, 'ماهر المعيقلي', 'Maher Al-Muaiqly'),
  AyahReciter(Reciters.sudouk, 'عبد الرحمن السديس', 'Abdul Rahman Al-Sudais'),
  AyahReciter(Reciters.shuraym, 'سعود الشريم', 'Saud Al-Shuraim'),
  AyahReciter(Reciters.ghamadi, 'سعد الغامدي', 'Saad Al-Ghamdi'),
  AyahReciter(
    'Abu_Bakr_Ash-Shaatree_128kbps',
    'أبو بكر الشاطري',
    'Abu Bakr Al-Shatri',
  ),
  AyahReciter(
    'Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net',
    'أحمد بن علي العجمي',
    'Ahmed Al-Ajmi',
  ),
  AyahReciter('Yasser_Ad-Dussary_128kbps', 'ياسر الدوسري', 'Yasser Al-Dosari'),
  AyahReciter('Abdullah_Basfar_192kbps', 'عبد الله بصفر', 'Abdullah Basfar'),
  AyahReciter('Hudhaify_128kbps', 'علي الحذيفي', 'Ali Al-Hudhaify'),
  AyahReciter('Nasser_Alqatami_128kbps', 'ناصر القطامي', 'Nasser Al-Qatami'),
];

AyahReciter ayahReciterById(String? id) => kAyahReciters.firstWhere(
  (reciter) => reciter.id == id,
  orElse: () => kAyahReciters.first,
);
