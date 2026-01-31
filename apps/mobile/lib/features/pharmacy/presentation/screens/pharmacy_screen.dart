import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/pharmacy.dart';
import '../../../../core/constants.dart';
import '../../data/pharmacy_provider.dart';
import '../widgets/pharmacy_card.dart';
import '../widgets/city_selector.dart';

class PharmacyScreen extends ConsumerStatefulWidget {
  const PharmacyScreen({super.key});

  @override
  ConsumerState<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends ConsumerState<PharmacyScreen> {
  String? _selectedCity;
  String? _selectedDistrict;
  bool _useLocation = false;

  @override
  Widget build(BuildContext context) {
    final query = PharmacyQuery(
      city: _selectedCity,
      district: _selectedDistrict,
      useLocation: _useLocation,
    );
    final pharmaciesAsync = ref.watch(pharmaciesProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nöbetçi Eczane'),
        actions: [
          IconButton(
            icon: Icon(
              _useLocation ? Icons.location_on : Icons.location_off,
              color:
                  _useLocation ? Theme.of(context).colorScheme.primary : null,
            ),
            onPressed: () {
              setState(() {
                _useLocation = !_useLocation;
                if (_useLocation) {
                  _selectedCity = null;
                  _selectedDistrict = null;
                }
              });
            },
            tooltip: 'Konumumu Kullan',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search/Filter Section
          if (!_useLocation) ...[
            Padding(
              padding: const EdgeInsets.all(16),
              child: CitySelector(
                selectedCity: _selectedCity,
                selectedDistrict: _selectedDistrict,
                onCityChanged: (city) {
                  setState(() {
                    _selectedCity = city;
                    _selectedDistrict = null;
                  });
                },
                onDistrictChanged: (district) {
                  setState(() {
                    _selectedDistrict = district;
                  });
                },
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text('Konumunuza en yakın nöbetçi eczaneler'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],

          // Results
          Expanded(
            child: pharmaciesAsync.when(
              data: (pharmacies) {
                if (pharmacies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_pharmacy_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedCity == null && !_useLocation
                              ? 'Şehir seçin veya konumunuzu kullanın'
                              : 'Nöbetçi eczane bulunamadı',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: pharmacies.length,
                  itemBuilder: (context, index) {
                    return PharmacyCard(
                      pharmacy: pharmacies[index],
                      onCall: () => _callPharmacy(pharmacies[index]),
                      onDirections: () => _openDirections(pharmacies[index]),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Hata: $error'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(pharmaciesProvider(query)),
                      child: const Text('Tekrar Dene'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Disclaimer
          Container(
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Text(
              AppConstants.medicalDisclaimer,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _callPharmacy(Pharmacy pharmacy) async {
    final uri = Uri.parse('tel:${pharmacy.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _openDirections(Pharmacy pharmacy) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${pharmacy.latitude},${pharmacy.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
