class ZekrEntity {
  /// عدد مرات الذكر (حقل number في ملفات assets/data)
  final int count;
  final String hint;
  final String txt;

  ZekrEntity({required this.count, required this.hint, required this.txt});

  factory ZekrEntity.fromJson(Map<String, dynamic> json) {
    final number = json['number'];
    return ZekrEntity(
      count: number is int && number > 0 ? number : 1,
      hint: json['hint'],
      txt: json['text'],
    );
  }
}
