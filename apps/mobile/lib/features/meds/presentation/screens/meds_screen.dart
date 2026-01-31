import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/models/medication.dart';
import '../../data/medication_provider.dart';
import '../widgets/medication_card.dart';
import '../widgets/add_medication_sheet.dart';

class MedsScreen extends ConsumerWidget {
  const MedsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medications = ref.watch(medicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('İlaçlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // TODO: Navigate to medication history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Geçmiş yakında eklenecek')),
              );
            },
            tooltip: 'Geçmiş',
          ),
        ],
      ),
      body: medications.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: medications.length,
              itemBuilder: (context, index) {
                final med = medications[index];
                return MedicationCard(
                  medication: med,
                  onTaken: () => ref
                      .read(medicationsProvider.notifier)
                      .markAsTaken(med.id),
                  onEdit: () => _showEditSheet(context, ref, med),
                  onDelete: () => _confirmDelete(context, ref, med),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('İlaç Ekle'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 24),
            Text(
              'Henüz ilaç eklenmedi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'İlaç hatırlatmaları almak için ilaçlarınızı ekleyin',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddMedicationSheet(
        onSave: (medication) {
          ref.read(medicationsProvider.notifier).addMedication(medication);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, Medication med) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddMedicationSheet(
        medication: med,
        onSave: (medication) {
          ref.read(medicationsProvider.notifier).updateMedication(medication);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Medication med) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('İlacı Sil'),
        content: Text('${med.name} ilacını silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(medicationsProvider.notifier).deleteMedication(med.id);
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
