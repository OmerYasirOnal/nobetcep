// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter packages pub run build_runner build

part of 'medication.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleTypeAdapter extends TypeAdapter<ScheduleType> {
  @override
  final int typeId = 0;

  @override
  ScheduleType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ScheduleType.fixedTimes;
      case 1:
        return ScheduleType.interval;
      default:
        return ScheduleType.fixedTimes;
    }
  }

  @override
  void write(BinaryWriter writer, ScheduleType obj) {
    switch (obj) {
      case ScheduleType.fixedTimes:
        writer.writeByte(0);
        break;
      case ScheduleType.interval:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicationAdapter extends TypeAdapter<Medication> {
  @override
  final int typeId = 1;

  @override
  Medication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medication(
      id: fields[0] as String,
      name: fields[1] as String,
      dose: fields[2] as String?,
      instructions: fields[3] as String?,
      scheduleType: fields[4] as ScheduleType,
      fixedTimes: (fields[5] as List).cast<String>(),
      intervalHours: fields[6] as int?,
      startDate: fields[7] as DateTime?,
      endDate: fields[8] as DateTime?,
      isActive: fields[9] as bool,
      createdAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Medication obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dose)
      ..writeByte(3)
      ..write(obj.instructions)
      ..writeByte(4)
      ..write(obj.scheduleType)
      ..writeByte(5)
      ..write(obj.fixedTimes)
      ..writeByte(6)
      ..write(obj.intervalHours)
      ..writeByte(7)
      ..write(obj.startDate)
      ..writeByte(8)
      ..write(obj.endDate)
      ..writeByte(9)
      ..write(obj.isActive)
      ..writeByte(10)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicationLogAdapter extends TypeAdapter<MedicationLog> {
  @override
  final int typeId = 2;

  @override
  MedicationLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicationLog(
      id: fields[0] as String,
      medicationId: fields[1] as String,
      scheduledTime: fields[2] as DateTime,
      takenTime: fields[3] as DateTime?,
      isTaken: fields[4] as bool,
      isSnoozed: fields[5] as bool,
      snoozedUntil: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, MedicationLog obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medicationId)
      ..writeByte(2)
      ..write(obj.scheduledTime)
      ..writeByte(3)
      ..write(obj.takenTime)
      ..writeByte(4)
      ..write(obj.isTaken)
      ..writeByte(5)
      ..write(obj.isSnoozed)
      ..writeByte(6)
      ..write(obj.snoozedUntil);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
