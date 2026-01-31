import 'package:flutter_test/flutter_test.dart';

import 'package:nobetcep/core/models/pharmacy.dart';
import 'package:nobetcep/core/models/medication.dart';
import 'package:nobetcep/core/models/chat_message.dart';

void main() {
  group('Pharmacy Model', () {
    test('fromJson creates valid Pharmacy', () {
      final json = {
        'id': 'p1',
        'name': 'Test Eczanesi',
        'address': 'Test Cad. No:1',
        'city': 'İstanbul',
        'district': 'Kadıköy',
        'phone': '0216 123 45 67',
        'latitude': 40.9833,
        'longitude': 29.0333,
        'is_on_duty': true,
        'distance_km': 1.5,
      };

      final pharmacy = Pharmacy.fromJson(json);

      expect(pharmacy.id, 'p1');
      expect(pharmacy.name, 'Test Eczanesi');
      expect(pharmacy.city, 'İstanbul');
      expect(pharmacy.distanceKm, 1.5);
      expect(pharmacy.formattedDistance, '1.5 km');
    });

    test('formattedDistance shows meters for < 1km', () {
      const pharmacy = Pharmacy(
        id: 'p1',
        name: 'Test',
        address: 'Test',
        city: 'Test',
        district: 'Test',
        phone: '123',
        latitude: 0,
        longitude: 0,
        distanceKm: 0.5,
      );

      expect(pharmacy.formattedDistance, '500 m');
    });
  });

  group('Medication Model', () {
    test('scheduleDisplayText shows fixed times', () {
      final medication = Medication(
        id: 'm1',
        name: 'Parol',
        scheduleType: ScheduleType.fixedTimes,
        fixedTimes: ['08:00', '20:00'],
      );

      expect(medication.scheduleDisplayText, '08:00, 20:00');
    });

    test('scheduleDisplayText shows interval', () {
      final medication = Medication(
        id: 'm1',
        name: 'Vitamin',
        scheduleType: ScheduleType.interval,
        intervalHours: 8,
      );

      expect(medication.scheduleDisplayText, 'Her 8 saatte bir');
    });
  });

  group('ChatMessage Model', () {
    test('fromJson creates valid ChatMessage', () {
      final json = {
        'response': 'Merhaba!',
        'has_disclaimer': false,
      };

      final message = ChatMessage.fromJson(json);

      expect(message.content, 'Merhaba!');
      expect(message.isUser, false);
      expect(message.hasDisclaimer, false);
    });
  });
}
