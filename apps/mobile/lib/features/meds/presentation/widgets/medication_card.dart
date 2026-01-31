import 'package:flutter/material.dart';

import '../../../../core/models/medication.dart';

class MedicationCard extends StatelessWidget {
  final Medication medication;
  final VoidCallback? onTaken;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicationCard({
    super.key,
    required this.medication,
    this.onTaken,
    this.onEdit,
    this.onDelete,
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: medication.isActive
                        ? theme.colorScheme.primaryContainer
                        : theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.medication,
                    color: medication.isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medication.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (medication.dose != null)
                        Text(
                          medication.dose!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit),
                          SizedBox(width: 8),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: theme.colorScheme.error),
                          const SizedBox(width: 8),
                          Text(
                            'Sil',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Schedule
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 18,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 8),
                Text(
                  medication.scheduleDisplayText,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),

            if (medication.instructions != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    medication.instructions!,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: medication.isActive ? onTaken : null,
                icon: const Icon(Icons.check),
                label: const Text('Aldım'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
