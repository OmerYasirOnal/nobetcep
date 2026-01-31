import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/pharmacy.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/location_service.dart';

/// Provider for fetching pharmacies
final pharmaciesProvider = FutureProvider.family<List<Pharmacy>, PharmacyQuery>(
  (ref, query) async {
    // If using location
    if (query.useLocation) {
      final position = await LocationService.instance.getCurrentPosition();
      if (position != null) {
        return _fetchPharmacies(
          lat: position.latitude,
          lon: position.longitude,
        );
      }
      return [];
    }

    // If city is selected
    if (query.city != null) {
      return _fetchPharmacies(
        city: query.city,
        district: query.district,
      );
    }

    return [];
  },
);

/// Query parameters for pharmacy provider
class PharmacyQuery {
  final String? city;
  final String? district;
  final bool useLocation;

  const PharmacyQuery({
    this.city,
    this.district,
    this.useLocation = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PharmacyQuery &&
        other.city == city &&
        other.district == district &&
        other.useLocation == useLocation;
  }

  @override
  int get hashCode => Object.hash(city, district, useLocation);
}

/// Helper to create query
PharmacyQuery createPharmacyQuery({
  String? city,
  String? district,
  bool useLocation = false,
}) {
  return PharmacyQuery(
    city: city,
    district: district,
    useLocation: useLocation,
  );
}

/// Fetch pharmacies from API
Future<List<Pharmacy>> _fetchPharmacies({
  String? city,
  String? district,
  double? lat,
  double? lon,
}) async {
  try {
    final queryParams = <String, dynamic>{};
    if (city != null) queryParams['city'] = city;
    if (district != null) queryParams['district'] = district;
    if (lat != null) queryParams['lat'] = lat;
    if (lon != null) queryParams['lon'] = lon;

    final response = await ApiService.instance.get(
      '/pharmacies/on-duty',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;
      final pharmaciesJson = data['pharmacies'] as List<dynamic>;
      return pharmaciesJson
          .map((json) => Pharmacy.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    return [];
  } catch (e) {
    // Return mock data if API fails
    return _getMockPharmacies(city: city, district: district);
  }
}

/// Mock data for development/offline
List<Pharmacy> _getMockPharmacies({String? city, String? district}) {
  final allPharmacies = [
    const Pharmacy(
      id: 'p1',
      name: 'Hayat Eczanesi',
      address: 'Bağdat Cad. No:123',
      city: 'İstanbul',
      district: 'Kadıköy',
      phone: '0216 123 45 67',
      latitude: 40.9833,
      longitude: 29.0333,
      distanceKm: 0.5,
    ),
    const Pharmacy(
      id: 'p2',
      name: 'Sağlık Eczanesi',
      address: 'Moda Cad. No:45',
      city: 'İstanbul',
      district: 'Kadıköy',
      phone: '0216 234 56 78',
      latitude: 40.9789,
      longitude: 29.0245,
      distanceKm: 1.2,
    ),
    const Pharmacy(
      id: 'p3',
      name: 'Merkez Eczanesi',
      address: 'İstiklal Cad. No:78',
      city: 'İstanbul',
      district: 'Beyoğlu',
      phone: '0212 345 67 89',
      latitude: 41.0336,
      longitude: 28.9784,
      distanceKm: 3.5,
    ),
    const Pharmacy(
      id: 'p4',
      name: 'Yıldız Eczanesi',
      address: 'Atatürk Bulvarı No:56',
      city: 'Ankara',
      district: 'Çankaya',
      phone: '0312 567 89 01',
      latitude: 39.9208,
      longitude: 32.8541,
      distanceKm: 0.8,
    ),
    const Pharmacy(
      id: 'p5',
      name: 'Ege Eczanesi',
      address: 'Kordon Boyu No:89',
      city: 'İzmir',
      district: 'Konak',
      phone: '0232 789 01 23',
      latitude: 38.4237,
      longitude: 27.1428,
      distanceKm: 1.5,
    ),
  ];

  return allPharmacies.where((p) {
    if (city != null && !p.city.toLowerCase().contains(city.toLowerCase())) {
      return false;
    }
    if (district != null &&
        !p.district.toLowerCase().contains(district.toLowerCase())) {
      return false;
    }
    return true;
  }).toList();
}
