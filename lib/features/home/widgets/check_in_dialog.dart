import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/providers/sobriety_provider.dart';
import '../../../core/models/sobriety_tracking_model.dart';

class CheckInDialog extends StatefulWidget {
  const CheckInDialog({super.key});

  @override
  State<CheckInDialog> createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  final _formKey = GlobalKey<FormState>();
  String _mood = 'Good';
  final _noteController = TextEditingController();
  final List<String> _selectedTriggers = [];
  final List<String> _selectedCopingStrategies = [];

  final List<String> _moods = [
    'Great',
    'Good',
    'Neutral',
    'Struggling',
    'Difficult',
  ];

  final List<String> _triggers = [
    'Stress',
    'Social situations',
    'Boredom',
    'Celebration',
    'Anxiety',
    'Depression',
    'Peer pressure',
    'Other',
  ];

  final List<String> _copingStrategies = [
    'Exercise',
    'Meditation',
    'Reading',
    'Talking to someone',
    'Journaling',
    'Deep breathing',
    'Taking a walk',
    'Other',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitCheckIn() {
    if (_formKey.currentState!.validate()) {
      final checkIn = CheckIn(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        mood: _mood,
        note: _noteController.text,
        triggers: _selectedTriggers,
        copingStrategies: _selectedCopingStrategies,
      );

      context.read<SobrietyProvider>().checkIn(checkIn);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Daily Check-in',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _mood,
                decoration: const InputDecoration(
                  labelText: 'How are you feeling today?',
                  border: OutlineInputBorder(),
                ),
                items: _moods.map((mood) {
                  return DropdownMenuItem(
                    value: mood,
                    child: Text(mood),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _mood = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              const Text(
                'Triggers (if any)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _triggers.map((trigger) {
                  final isSelected = _selectedTriggers.contains(trigger);
                  return FilterChip(
                    label: Text(trigger),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedTriggers.add(trigger);
                        } else {
                          _selectedTriggers.remove(trigger);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                'Coping Strategies',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _copingStrategies.map((strategy) {
                  final isSelected = _selectedCopingStrategies.contains(strategy);
                  return FilterChip(
                    label: Text(strategy),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCopingStrategies.add(strategy);
                        } else {
                          _selectedCopingStrategies.remove(strategy);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitCheckIn,
                child: const Text('Submit Check-in'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 