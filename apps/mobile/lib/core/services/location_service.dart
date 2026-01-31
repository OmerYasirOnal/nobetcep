import 'package:geolocator/geolocator.dart';

/// Service for handling device location
class LocationService {
  LocationService._();

  static final LocationService instance = LocationService._();

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check and request location permissions
  Future<LocationPermission> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Get current position
  Future<Position?> getCurrentPosition() async {
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    final permission = await checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two points in km
  double calculateDistance(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
  ) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon) /
        1000;
  }

  /// Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app settings (for permissions)
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}
