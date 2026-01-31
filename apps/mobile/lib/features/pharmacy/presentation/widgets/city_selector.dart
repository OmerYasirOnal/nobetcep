import 'package:flutter/material.dart';

class CitySelector extends StatelessWidget {
  final String? selectedCity;
  final String? selectedDistrict;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onDistrictChanged;

  const CitySelector({
    super.key,
    this.selectedCity,
    this.selectedDistrict,
    required this.onCityChanged,
    required this.onDistrictChanged,
  });

  // Sample cities - in production, load from API
  static const Map<String, List<String>> cityDistricts = {
    'İstanbul': ['Kadıköy', 'Beşiktaş', 'Beyoğlu', 'Şişli', 'Üsküdar', 'Fatih'],
    'Ankara': ['Çankaya', 'Keçiören', 'Mamak', 'Yenimahalle', 'Etimesgut'],
    'İzmir': ['Konak', 'Karşıyaka', 'Bornova', 'Buca', 'Alsancak'],
    'Antalya': ['Muratpaşa', 'Konyaaltı', 'Kepez', 'Lara', 'Alanya'],
    'Bursa': ['Nilüfer', 'Osmangazi', 'Yıldırım', 'Gemlik'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // City Dropdown
        DropdownButtonFormField<String>(
          initialValue: selectedCity,
          decoration: const InputDecoration(
            labelText: 'Şehir',
            prefixIcon: Icon(Icons.location_city),
          ),
          items: cityDistricts.keys.map((city) {
            return DropdownMenuItem(
              value: city,
              child: Text(city),
            );
          }).toList(),
          onChanged: onCityChanged,
          hint: const Text('Şehir Seçin'),
        ),

        const SizedBox(height: 12),

        // District Dropdown
        DropdownButtonFormField<String>(
          initialValue: selectedDistrict,
          decoration: const InputDecoration(
            labelText: 'İlçe',
            prefixIcon: Icon(Icons.map),
          ),
          items: selectedCity != null
              ? (cityDistricts[selectedCity] ?? []).map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text(district),
                  );
                }).toList()
              : [],
          onChanged: selectedCity != null ? onDistrictChanged : null,
          hint: Text(
            selectedCity != null ? 'İlçe Seçin' : 'Önce şehir seçin',
          ),
        ),
      ],
    );
  }
}
