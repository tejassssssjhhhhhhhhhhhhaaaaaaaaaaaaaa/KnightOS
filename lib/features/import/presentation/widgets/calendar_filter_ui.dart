import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarFilterUI extends ConsumerStatefulWidget {
  const CalendarFilterUI({super.key});

  @override
  ConsumerState<CalendarFilterUI> createState() => _CalendarFilterUIState();
}

class _CalendarFilterUIState extends ConsumerState<CalendarFilterUI> {
  bool _importWork = true;
  bool _importPersonal = true;
  bool _importHolidays = false;
  bool _importBirthdays = false;
  bool _includeDeclined = false;
  bool _includeCancelled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calendar Import Settings',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose which events to import into your KnightOS evidence graph.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          _buildSection('Calendar Types'),
          SwitchListTile(
            title: const Text('Work Calendars'),
            value: _importWork,
            onChanged: (v) => setState(() => _importWork = v),
          ),
          SwitchListTile(
            title: const Text('Personal Calendars'),
            value: _importPersonal,
            onChanged: (v) => setState(() => _importPersonal = v),
          ),
          SwitchListTile(
            title: const Text('Holidays'),
            value: _importHolidays,
            onChanged: (v) => setState(() => _importHolidays = v),
          ),
          SwitchListTile(
            title: const Text('Birthdays'),
            value: _importBirthdays,
            onChanged: (v) => setState(() => _importBirthdays = v),
          ),

          const Divider(height: 32),
          _buildSection('Filters'),
          CheckboxListTile(
            title: const Text('Include Declined Events'),
            value: _includeDeclined,
            onChanged: (v) => setState(() => _includeDeclined = v ?? false),
          ),
          CheckboxListTile(
            title: const Text('Include Cancelled Events'),
            value: _includeCancelled,
            onChanged: (v) => setState(() => _includeCancelled = v ?? false),
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Settings'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
