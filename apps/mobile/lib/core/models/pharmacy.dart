/// Pharmacy model
class Pharmacy {
  final String id;
  final String name;
  final String address;
  final String city;
  final String district;
  final String phone;
  final double latitude;
  final double longitude;
  final bool isOnDuty;
  final double? distanceKm;

  const Pharmacy({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.district,
    required this.phone,
    required this.latitude,
    required this.longitude,
    this.isOnDuty = true,
    this.distanceKm,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      district: json['district'] as String,
      phone: json['phone'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isOnDuty: json['is_on_duty'] as bool? ?? true,
      distanceKm: json['distance_km'] != null
          ? (json['distance_km'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'city': city,
      'district': district,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'is_on_duty': isOnDuty,
      'distance_km': distanceKm,
    };
  }

  /// Format distance for display
  String get formattedDistance {
    if (distanceKm == null) return '';
    if (distanceKm! < 1) {
      return '${(distanceKm! * 1000).round()} m';
    }
    return '${distanceKm!.toStringAsFixed(1)} km';
  }

  Pharmacy copyWith({
    String? id,
    String? name,
    String? address,
    String? city,
    String? district,
    String? phone,
    double? latitude,
    double? longitude,
    bool? isOnDuty,
    double? distanceKm,
  }) {
    return Pharmacy(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      city: city ?? this.city,
      district: district ?? this.district,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isOnDuty: isOnDuty ?? this.isOnDuty,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }
}
