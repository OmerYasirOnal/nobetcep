import 'package:flutter/material.dart';

import '../../../../core/models/pharmacy.dart';

class PharmacyCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final VoidCallback? onCall;
  final VoidCallback? onDirections;

  const PharmacyCard({
    super.key,
    required this.pharmacy,
    this.onCall,
    this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.local_pharmacy,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacy.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (pharmacy.distanceKm != null)
                        Text(
                          pharmacy.formattedDistance,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (pharmacy.isOnDuty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Nöbetçi',
                      style: TextStyle(
                        color: Colors.green.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${pharmacy.address}\n${pharmacy.district}, ${pharmacy.city}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Phone
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Text(
                  pharmacy.phone,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onCall,
                    icon: const Icon(Icons.phone),
                    label: const Text('Ara'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.directions),
                    label: const Text('Yol Tarifi'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
