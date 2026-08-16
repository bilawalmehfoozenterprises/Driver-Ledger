import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/enums/enums.dart';

/// Shift selector, join date picker, and pickup/dropoff location fields.
class TransportDetailsFields extends StatelessWidget {
  final Shift selectedShift;
  final ValueChanged<Shift> onShiftChanged;
  final DateTime joinDate;
  final VoidCallback onSelectJoinDate;
  final TextEditingController pickupController;
  final TextEditingController dropoffController;

  const TransportDetailsFields({
    super.key,
    required this.selectedShift,
    required this.onShiftChanged,
    required this.joinDate,
    required this.onSelectJoinDate,
    required this.pickupController,
    required this.dropoffController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Shift', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<Shift>(
            segments: const [
              ButtonSegment(value: .morning, label: Text('Morning')),
              ButtonSegment(value: .afternoon, label: Text('Afternoon')),
              ButtonSegment(value: .both, label: Text('Both')),
            ],
            selected: {selectedShift},
            onSelectionChanged: (selection) =>
                onShiftChanged(selection.first),
          ),
        ),
        const SizedBox(height: 16),
        Card.outlined(
          margin: .zero,
          child: ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: const Text('Join date'),
            subtitle: Text(DateFormat('dd MMM yyyy').format(joinDate)),
            trailing: const Icon(Icons.chevron_right),
            onTap: onSelectJoinDate,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: pickupController,
          textCapitalization: .sentences,
          decoration: const InputDecoration(
            labelText: 'Pickup location (optional)',
            prefixIcon: Icon(Icons.location_on_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: dropoffController,
          textCapitalization: .sentences,
          decoration: const InputDecoration(
            labelText: 'Drop-off location (optional)',
            prefixIcon: Icon(Icons.school_outlined),
          ),
        ),
      ],
    );
  }
}
