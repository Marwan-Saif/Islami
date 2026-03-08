import 'package:hive/hive.dart';
import 'package:islami/core/services/shared_prefs.dart';
import 'package:islami/features/Sebha/presentation/views/local_sypha.dart';

class SebhaService {
  late Box<LocalSypha> _syphaBox;
  final String _totalKey = 'total'; 

  // 1. (Initialization)
  Future<void> init() async {
    _syphaBox = Hive.box<LocalSypha>('SyphaBox');

    if (_syphaBox.isEmpty) {
      await _syphaBox.addAll([
        LocalSypha(name: "سبحان الله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "الحمد لله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "لا إله إلا الله", counter: '0', historyCounter: '0'),
        LocalSypha(name: "الله أكبر", counter: '0', historyCounter: '0'),
        LocalSypha(name: 'استغفر الله', counter: '0', historyCounter: '0'),
      ]);
    }
  }

  // 2. (Get All Azkar) 
  List<LocalSypha> getAllAzkar() {
    return _syphaBox.values.toList();
  }

  LocalSypha getZekrAt(int index) {
    return _syphaBox.getAt(index)!;
  }

  // 3.(Increment Counter)
  void incrementCounter(int index) {
    var item = _syphaBox.getAt(index)!;
    int currentCount = int.parse(item.counter);
    item.counter = (currentCount + 1).toString();
    _syphaBox.putAt(index, item);
  }

  // 4 (History)
  void moveCurrentToHistory() {
    for (int i = 0; i < _syphaBox.length; i++) {
      var item = _syphaBox.getAt(i)!;
      int history = int.parse(item.historyCounter);
      int current = int.parse(item.counter);
      
      item.historyCounter = (history + current).toString();
      item.counter = '0'; 
      _syphaBox.putAt(i, item);
    }
    Prefs.saveData(key: _totalKey, value: 0);
  }

  // 5. (Clear History)
  void clearHistoryData() {
    for (int i = 0; i < _syphaBox.length; i++) {
      var item = _syphaBox.getAt(i)!;
      item.historyCounter = '0';
      _syphaBox.putAt(i, item);
    }
  }

  // 6. (Get Total History)
  int getTotalHistory() {
    int totalHistory = 0;
    for (var item in _syphaBox.values) {
      totalHistory += int.parse(item.historyCounter);
    }
    return totalHistory;
  }

  // 7. (Get Global Total)
  int getGlobalTotal() {
    return Prefs.getData(key: _totalKey) ?? 0;
  }

  void incrementGlobalTotal() {
    int current = getGlobalTotal();
    Prefs.saveData(key: _totalKey, value: current + 1);
  }
}