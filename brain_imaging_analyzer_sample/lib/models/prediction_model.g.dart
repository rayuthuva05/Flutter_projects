// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredictionModelAdapter extends TypeAdapter<PredictionModel> {
  @override
  final int typeId = 0;

  @override
  PredictionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PredictionModel(
      subjectId: fields[0] as String,
      subjectType: fields[1] as String,
      prediction: fields[2] as String,
      confidence: fields[3] as double,
      filepath: fields[4] as String,
      date: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PredictionModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.subjectId)
      ..writeByte(1)
      ..write(obj.subjectType)
      ..writeByte(2)
      ..write(obj.prediction)
      ..writeByte(3)
      ..write(obj.confidence)
      ..writeByte(4)
      ..write(obj.filepath)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredictionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
