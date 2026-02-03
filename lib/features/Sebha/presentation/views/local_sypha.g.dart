// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_sypha.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalSyphaAdapter extends TypeAdapter<LocalSypha> {
  @override
  final int typeId = 0;

  @override
  LocalSypha read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalSypha(
      name: fields[0] as String,
      counter: fields[1] as String,
      historyCounter: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalSypha obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.counter)
      ..writeByte(2)
      ..write(obj.historyCounter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalSyphaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
