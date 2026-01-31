import 'package:flutter/material.dart';

import '../../../../core/models/medication.dart';

class AddMedicationSheet extends StatefulWidget {
  final Medication? medication;
  final ValueChanged<Medication> onSave;

  const AddMedicationSheet({
    super.key,
    this.medication,
    required this.onSave,
  });

  @override
  State<AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<AddMedicationSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _doseController;
  late final TextEditingController _instructionsController;

  ScheduleType _scheduleType = ScheduleType.fixedTimes;
  final List<TimeOfDay> _selectedTimes = [const TimeOfDay(hour: 8, minute: 0)];
  int _intervalHours = 8;

  bool get isEditing => widget.medication != null;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    _nameController = TextEditingController(text: med?.name ?? '');
    _doseController = TextEditingController(text: med?.dose ?? '');
    _instructionsController = TextEditingController(text: med?.instructions ?? '');

    if (med != null) {
      _scheduleType = med.scheduleType;
      if (med.fixedTimes.isNotEmpty) {
        _selectedTimes.clear();
        for (final timeStr in med.fixedTimes) {
          final parts = timeStr.split(':');
          if (parts.length == 2) {
            _selectedTimes.add(
              TimeOfDay(
                hour: int.parse(parts[0]),
                minute: int.parse(parts[1]),
              ),
            );
          }
        }
      }
      if (med.intervalHours != null) {
        _intervalHours = med.intervalHours!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEditing ? 'İlacı Düzenle' : 'Yeni İlaç Ekle',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'İlaç Adı *',
                    hintText: 'Örn: Parol',
                    prefixIcon: Icon(Icons.medication),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'İlaç adı gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dose
                TextFormField(
                  controller: _doseController,
                  decoration: const InputDecoration(
                    labelText: 'Doz',
                    hintText: 'Örn: 500mg, 1 tablet',
                    prefixIcon: Icon(Icons.scale),
                  ),
                ),
                const SizedBox(height: 16),

                // Instructions
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Kullanım Notu',
                    hintText: 'Örn: Yemeklerden sonra',
                    prefixIcon: Icon(Icons.note),
                  ),
                ),
                const SizedBox(height: 24),

                // Schedule Type
                Text(
                  'Hatırlatma Tipi',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                SegmentedButton<ScheduleType>(
                  segments: const [
                    ButtonSegment(
                      value: ScheduleType.fixedTimes,
                      label: Text('Sabit Saat'),
                      icon: Icon(Icons.access_time),
                    ),
                    ButtonSegment(
                      value: ScheduleType.interval,
                      label: Text('Aralıklı'),
                      icon: Icon(Icons.timer),
                    ),
                  ],
                  selected: {_scheduleType},
                  onSelectionChanged: (value) {
                    setState(() {
                      _scheduleType = value.first;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Schedule Options
                if (_scheduleType == ScheduleType.fixedTimes)
                  _buildFixedTimesSelector()
                else
                  _buildIntervalSelector(),

                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _save,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(isEditing ? 'Kaydet' : 'Ekle'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFixedTimesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hatırlatma Saatleri',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._selectedTimes.asMap().entries.map((entry) {
              final index = entry.key;
              final time = entry.value;
              return InputChip(
                label: Text(
                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                ),
                onDeleted: _selectedTimes.length > 1
                    ? () {
                        setState(() {
                          _selectedTimes.removeAt(index);
                        });
                      }
                    : null,
                onPressed: () => _selectTime(index),
              );
            }),
            ActionChip(
              label: const Text('+ Saat Ekle'),
              onPressed: _addTime,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIntervalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Her $_intervalHours saatte bir',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Slider(
          value: _intervalHours.toDouble(),
          min: 1,
          max: 24,
          divisions: 23,
          label: '$_intervalHours saat',
          onChanged: (value) {
            setState(() {
              _intervalHours = value.round();
            });
          },
        ),
      ],
    );
  }

  Future<void> _selectTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTimes[index],
    );
    if (time != null) {
      setState(() {
        _selectedTimes[index] = time;
      });
    }
  }

  Future<void> _addTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (time != null) {
      setState(() {
        _selectedTimes.add(time);
      });
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final medication = Medication(
      id: widget.medication?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      dose: _doseController.text.isEmpty ? null : _doseController.text,
      instructions: _instructionsController.text.isEmpty
          ? null
          : _instructionsController.text,
      scheduleType: _scheduleType,
      fixedTimes: _scheduleType == ScheduleType.fixedTimes
          ? _selectedTimes
              .map(
                (t) =>
                    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
              )
              .toList()
          : [],
      intervalHours:
          _scheduleType == ScheduleType.interval ? _intervalHours : null,
      isActive: true,
      createdAt: widget.medication?.createdAt,
    );

    widget.onSave(medication);
  }
}
