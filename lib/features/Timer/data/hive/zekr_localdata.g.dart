// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zekr_localdata.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ZekrLocalDataMoelAdapter extends TypeAdapter<ZekrLocalDataMoel> {
  @override
  final int typeId = 1;

  @override
  ZekrLocalDataMoel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ZekrLocalDataMoel(
      zekrName: fields[0] as String,
      zekrBody: fields[1] as String,
      zekrtime: fields[2] as String,
      zekrAllawed: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ZekrLocalDataMoel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.zekrName)
      ..writeByte(1)
      ..write(obj.zekrBody)
      ..writeByte(2)
      ..write(obj.zekrtime)
      ..writeByte(3)
      ..write(obj.zekrAllawed);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZekrLocalDataMoelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
