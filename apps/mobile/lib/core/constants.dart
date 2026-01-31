/// API Constants
class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const Duration timeout = Duration(seconds: 30);
}

/// Storage Keys
class StorageKeys {
  StorageKeys._();

  static const String pharmacyCache = 'pharmacy_cache';
  static const String medications = 'medications';
  static const String reminders = 'reminders';
  static const String settings = 'settings';
}

/// Notification Constants
class NotificationConstants {
  NotificationConstants._();

  static const String channelId = 'medication_reminders';
  static const String channelName = 'İlaç Hatırlatmaları';
  static const String channelDescription = 'İlaç alma zamanı bildirimleri';

  /// Maximum scheduled notifications (iOS limit)
  static const int maxScheduledNotifications = 64;

  /// Rolling window size (days to schedule ahead)
  static const int schedulingWindowDays = 7;
}

/// App Constants
class AppConstants {
  AppConstants._();

  static const String appName = 'NobetCep';
  static const String version = '1.0.0';

  /// Disclaimer text
  static const String medicalDisclaimer =
      '⚠️ Bu uygulama tıbbi tavsiye vermez. İlaç kullanımı ve dozaj '
      'konusunda mutlaka doktorunuza veya eczacınıza danışın.';
}
