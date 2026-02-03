import 'package:get_it/get_it.dart';
import 'package:islami/features/Quran/data/repo/quran_repo_impl.dart';
import 'package:islami/features/Quran/domain/quran_repo.dart';
import 'package:islami/features/Timer/data/zekr_repo_impl.dart';
import 'package:islami/features/Timer/domain/zekr_repo.dart';

final getit = GetIt.instance;

void setUpServiceLocator() {
  getit.registerSingleton<ZekrRepo>(ZekrRepoImpl());
  getit.registerSingleton<QuranRepo>(QuranRepoImpl());
  // getit.registerSingleton<FirebaseAuthServices>(FirebaseAuthServices());
  // getit.registerSingleton<DatabaseService>(FireStoreService());
  // getit.registerSingleton<AuthRepo>(
  //     AuthRepoImpl(getit.get<FirebaseAuthServices>(), getit.get<DatabaseService>()));
  // getit.registerSingleton<ApiServices>(ApiServices(Dio()));
  // getit.registerSingleton<SearchRepoImpl>(SearchRepoImpl(apiServices: ApiServices(Dio())));

  // getit.registerSingleton<HomeRepoImpl>(HomeRepoImpl(getit.get<ApiServices>()));
}
