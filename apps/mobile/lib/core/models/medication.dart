import 'package:hive/hive.dart';

part 'medication.g.dart';

/// Schedule type for medication reminders
@HiveType(typeId: 0)
enum ScheduleType {
  @HiveField(0)
  fixedTimes, // Specific times each day

  @HiveField(1)
  interval, // Every X hours
}

/// Medication model
@HiveType(typeId: 1)
class Medication extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? dose; // e.g., "500mg", "1 tablet"

  @HiveField(3)
  final String? instructions; // e.g., "After meals"

  @HiveField(4)
  final ScheduleType scheduleType;

  @HiveField(5)
  final List<String> fixedTimes; // ["08:00", "20:00"] for fixedTimes type

  @HiveField(6)
  final int? intervalHours; // e.g., 8 for interval type

  @HiveField(7)
  final DateTime? startDate;

  @HiveField(8)
  final DateTime? endDate;

  @HiveField(9)
  final bool isActive;

  @HiveField(10)
  final DateTime createdAt;

  Medication({
    required this.id,
    required this.name,
    this.dose,
    this.instructions,
    required this.scheduleType,
    this.fixedTimes = const [],
    this.intervalHours,
    this.startDate,
    this.endDate,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Medication copyWith({
    String? id,
    String? name,
    String? dose,
    String? instructions,
    ScheduleType? scheduleType,
    List<String>? fixedTimes,
    int? intervalHours,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dose: dose ?? this.dose,
      instructions: instructions ?? this.instructions,
      scheduleType: scheduleType ?? this.scheduleType,
      fixedTimes: fixedTimes ?? this.fixedTimes,
      intervalHours: intervalHours ?? this.intervalHours,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Get display text for schedule
  String get scheduleDisplayText {
    if (scheduleType == ScheduleType.fixedTimes && fixedTimes.isNotEmpty) {
      return fixedTimes.join(', ');
    } else if (scheduleType == ScheduleType.interval && intervalHours != null) {
      return 'Her $intervalHours saatte bir';
    }
    return 'Belirtilmemiş';
  }
}

/// Record of medication intake
@HiveType(typeId: 2)
class MedicationLog extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String medicationId;

  @HiveField(2)
  final DateTime scheduledTime;

  @HiveField(3)
  final DateTime? takenTime;

  @HiveField(4)
  final bool isTaken;

  @HiveField(5)
  final bool isSnoozed;

  @HiveField(6)
  final DateTime? snoozedUntil;

  MedicationLog({
    required this.id,
    required this.medicationId,
    required this.scheduledTime,
    this.takenTime,
    this.isTaken = false,
    this.isSnoozed = false,
    this.snoozedUntil,
  });

  MedicationLog copyWith({
    String? id,
    String? medicationId,
    DateTime? scheduledTime,
    DateTime? takenTime,
    bool? isTaken,
    bool? isSnoozed,
    DateTime? snoozedUntil,
  }) {
    return MedicationLog(
      id: id ?? this.id,
      medicationId: medicationId ?? this.medicationId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      takenTime: takenTime ?? this.takenTime,
      isTaken: isTaken ?? this.isTaken,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
    );
  }
}
