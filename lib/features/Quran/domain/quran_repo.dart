import 'package:islami/features/Quran/data/models/surah_model.dart';

abstract class QuranRepo{
 Future<QuranModel> getQuranData();
}