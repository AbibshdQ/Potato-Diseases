// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiseaseModelAdapter extends TypeAdapter<DiseaseModel> {
  @override
  final int typeId = 1;

  @override
  DiseaseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiseaseModel(
      name: fields[0] as String,
      description: fields[1] as String?,
      prevention: (fields[2] as List?)?.cast<String>(),
      treatments: (fields[3] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DiseaseModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.prevention)
      ..writeByte(3)
      ..write(obj.treatments);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiseaseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
