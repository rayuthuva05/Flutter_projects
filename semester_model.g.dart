// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SemesterModelAdapter extends TypeAdapter<SemesterModel> {
  @override
  final int typeId = 0;

  @override
  SemesterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SemesterModel(
      year: fields[0] as int,
      semester: fields[1] as int,
      subjects: (fields[2] as List).cast<SubjectModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SemesterModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.year)
      ..writeByte(1)
      ..write(obj.semester)
      ..writeByte(2)
      ..write(obj.subjects);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemesterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
