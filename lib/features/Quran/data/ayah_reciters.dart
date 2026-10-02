import 'package:quran_with_tafsir/quran_with_tafsir.dart';

/// قارئ لسماع آية معينة (ملفات everyayah.com اللي باكدج quran_with_tafsir بتستخدمها)
class AyahReciter {
  const AyahReciter(this.id, this.name);
  final String id;
  final String name;

  String ayahUrl(int surah, int ayah) =>
      QuranService.instance.getAudioUrl(surah, ayah, reciterIdentifier: id);
}

const List<AyahReciter> kAyahReciters = [
  AyahReciter(Reciters.alafasy, 'مشاري العفاسي'),
  AyahReciter(Reciters.abdulBasit, 'عبد الباسط عبد الصمد (مرتل)'),
  AyahReciter(Reciters.abdulBasitMujawwad, 'عبد الباسط عبد الصمد (مجود)'),
  AyahReciter(Reciters.husary, 'محمود خليل الحصري'),
  AyahReciter(Reciters.husaryMujawwad, 'محمود خليل الحصري (مجود)'),
  AyahReciter('Husary_Muallim_128kbps', 'محمود خليل الحصري (المعلم)'),
  AyahReciter(Reciters.minshawi, 'محمد صديق المنشاوي (مرتل)'),
  AyahReciter(Reciters.minshawiMujawwad, 'محمد صديق المنشاوي (مجود)'),
  AyahReciter('Mustafa_Ismail_48kbps', 'مصطفى إسماعيل'),
  AyahReciter('Muhammad_Jibreel_128kbps', 'محمد جبريل'),
  AyahReciter(Reciters.maherMuaiqly, 'ماهر المعيقلي'),
  AyahReciter(Reciters.sudouk, 'عبد الرحمن السديس'),
  AyahReciter(Reciters.shuraym, 'سعود الشريم'),
  AyahReciter(Reciters.ghamadi, 'سعد الغامدي'),
  AyahReciter('Abu_Bakr_Ash-Shaatree_128kbps', 'أبو بكر الشاطري'),
  AyahReciter('Ahmed_ibn_Ali_al-Ajamy_128kbps_ketaballah.net', 'أحمد بن علي العجمي'),
  AyahReciter('Yasser_Ad-Dussary_128kbps', 'ياسر الدوسري'),
  AyahReciter('Abdullah_Basfar_192kbps', 'عبد الله بصفر'),
  AyahReciter('Hudhaify_128kbps', 'علي الحذيفي'),
  AyahReciter('Nasser_Alqatami_128kbps', 'ناصر القطامي'),
];

AyahReciter ayahReciterById(String? id) => kAyahReciters.firstWhere(
      (reciter) => reciter.id == id,
      orElse: () => kAyahReciters.first,
    );
