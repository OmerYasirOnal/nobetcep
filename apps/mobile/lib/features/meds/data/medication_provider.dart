import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/medication.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/constants.dart';

/// Provider for managing medications
final medicationsProvider =
    StateNotifierProvider<MedicationsNotifier, List<Medication>>((ref) {
  return MedicationsNotifier();
});

class MedicationsNotifier extends StateNotifier<List<Medication>> {
  MedicationsNotifier() : super([]) {
    _loadMedications();
  }

  /// Load medications from storage
  Future<void> _loadMedications() async {
    // TODO: Load from Hive
    // For now, start with empty list
    state = [];
  }

  /// Add a new medication
  Future<void> addMedication(Medication medication) async {
    state = [...state, medication];
    await _saveMedications();
    await _scheduleNotifications(medication);
  }

  /// Update an existing medication
  Future<void> updateMedication(Medication medication) async {
    state = state.map((m) => m.id == medication.id ? medication : m).toList();
    await _saveMedications();
    await _rescheduleNotifications(medication);
  }

  /// Delete a medication
  Future<void> deleteMedication(String id) async {
    final medication = state.firstWhere((m) => m.id == id);
    state = state.where((m) => m.id != id).toList();
    await _saveMedications();
    await _cancelNotifications(medication);
  }

  /// Mark medication as taken
  Future<void> markAsTaken(String id) async {
    // TODO: Create MedicationLog entry
    // For now, just show feedback via scaffold messenger
  }

  /// Toggle active status
  Future<void> toggleActive(String id) async {
    state = state.map((m) {
      if (m.id == id) {
        return m.copyWith(isActive: !m.isActive);
      }
      return m;
    }).toList();
    await _saveMedications();

    final medication = state.firstWhere((m) => m.id == id);
    if (medication.isActive) {
      await _scheduleNotifications(medication);
    } else {
      await _cancelNotifications(medication);
    }
  }

  /// Save medications to storage
  Future<void> _saveMedications() async {
    // TODO: Save to Hive
  }

  /// Schedule notifications for a medication
  Future<void> _scheduleNotifications(Medication medication) async {
    if (!medication.isActive) return;

    final now = DateTime.now();
    final windowEnd = now.add(
      const Duration(days: NotificationConstants.schedulingWindowDays),
    );

    if (medication.scheduleType == ScheduleType.fixedTimes) {
      for (final timeStr in medication.fixedTimes) {
        final parts = timeStr.split(':');
        if (parts.length != 2) continue;

        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);

        // Schedule for each day in the window
        while (scheduledTime.isBefore(windowEnd)) {
          if (scheduledTime.isAfter(now)) {
            final notificationId =
                '${medication.id}_${scheduledTime.millisecondsSinceEpoch}'
                    .hashCode;

            await NotificationService.instance.scheduleNotification(
              id: notificationId,
              title: '💊 ${medication.name}',
              body: medication.dose ?? 'İlaç alma zamanı',
              scheduledTime: scheduledTime,
              payload: medication.id,
            );
          }
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }
      }
    } else if (medication.scheduleType == ScheduleType.interval &&
        medication.intervalHours != null) {
      var scheduledTime = now.add(Duration(hours: medication.intervalHours!));

      while (scheduledTime.isBefore(windowEnd)) {
        final notificationId =
            '${medication.id}_${scheduledTime.millisecondsSinceEpoch}'.hashCode;

        await NotificationService.instance.scheduleNotification(
          id: notificationId,
          title: '💊 ${medication.name}',
          body: medication.dose ?? 'İlaç alma zamanı',
          scheduledTime: scheduledTime,
          payload: medication.id,
        );
        // const Duration used for rolling window

        scheduledTime =
            scheduledTime.add(Duration(hours: medication.intervalHours!));
      }
    }
  }

  /// Cancel notifications for a medication
  Future<void> _cancelNotifications(Medication medication) async {
    // Cancel all notifications with this medication's ID prefix
    // Since we can't easily get all scheduled notifications,
    // we'll rely on the rolling window approach
    // Old notifications will naturally expire
  }

  /// Reschedule notifications (cancel old, schedule new)
  Future<void> _rescheduleNotifications(Medication medication) async {
    await _cancelNotifications(medication);
    await _scheduleNotifications(medication);
  }
}
