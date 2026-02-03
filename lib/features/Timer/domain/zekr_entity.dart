class ZekrEntity {
  final int id;
  final String hint;
  final String txt;

  ZekrEntity({required this.id, required this.hint, required this.txt});

  factory ZekrEntity.fromJson(Map<String, dynamic> json) {
    return ZekrEntity(id: json['number'], hint: json['hint'], txt: json['text']);
  }
}
