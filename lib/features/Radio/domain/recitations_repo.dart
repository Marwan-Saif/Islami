import 'package:islami/features/Radio/data/models/reciter_model.dart';

abstract class RecitationsRepo {
  Future<List<ReciterModel>> getReciters();

  /// آخر قارئ ورواية اختارهم المستخدم (أو مشاري العفاسي لو مفيش)
  ({ReciterModel reciter, MoshafModel moshaf}) getLastSelection();

  Future<void> saveLastSelection(ReciterModel reciter, MoshafModel moshaf);
}
