import 'dart:convert';
import 'package:crypto/crypto.dart';

enum CalendarCategory {
  meeting,
  work,
  personal,
  birthday,
  holiday,
  travel,
  medical,
  reminder,
  unknown,
}

class GoogleCalendarNormalizer {
  /// Maps a raw Google Calendar Event to a KnightOS standardized Map.
  Map<String, dynamic> normalize(Map<String, dynamic> event, String calendarId) {
    final String eventId = event['id'] ?? '';
    final String summary = event['summary'] ?? 'Untitled Event';
    final String? description = event['description'];
    final String? location = event['location'];
    
    // Time handling
    final start = event['start']?['dateTime'] ?? event['start']?['date'];
    final end = event['end']?['dateTime'] ?? event['end']?['date'];
    
    final category = _classify(event, calendarId);

    return {
      'id': eventId,
      'title': summary,
      'description': description,
      'location': location,
      'start_time': start,
      'end_time': end,
      'source_name': 'Google Calendar: $summary',
      'mime_type': 'application/x-google-calendar-event',
      'calendar_id': calendarId,
      'category': category.name,
      'status': event['status'],
      'html_link': event['htmlLink'],
      'sequence': event['sequence'] ?? 0,
      'attendees_count': (event['attendees'] as List?)?.length ?? 0,
      'is_all_day': event['start']?['date'] != null,
      'raw_kind': event['kind'],
    };
  }

  /// Generates a Content-Addressable ID for the event to ensure deduplication.
  String generateCaid(Map<String, dynamic> normalizedData) {
    final key = '${normalizedData['calendar_id']}_${normalizedData['id']}_${normalizedData['sequence']}';
    return sha256.convert(utf8.encode(key)).toString();
  }

  CalendarCategory _classify(Map<String, dynamic> event, String calendarId) {
    final summary = (event['summary'] ?? '').toLowerCase();
    final description = (event['description'] ?? '').toLowerCase();
    
    // 1. Holiday/Birthday Detection
    if (summary.contains('birthday')) return CalendarCategory.birthday;
    if (event['kind'] == 'calendar#event' && (event['transparency'] == 'transparent')) {
      if (summary.contains('holiday')) return CalendarCategory.holiday;
    }

    // 2. Medical
    if (summary.contains('doctor') || summary.contains('dentist') || summary.contains('appointment') && description.contains('clinic')) {
      return CalendarCategory.medical;
    }

    // 3. Travel
    if (summary.contains('flight') || summary.contains('hotel') || summary.contains('train') || summary.contains('trip to')) {
      return CalendarCategory.travel;
    }

    // 4. Meeting vs Work
    final attendees = event['attendees'] as List?;
    if (attendees != null && attendees.isNotEmpty) {
      return CalendarCategory.meeting;
    }

    // 5. Work heuristics (based on calendar name or common keywords)
    if (calendarId.toLowerCase().contains('work') || summary.contains('jira') || summary.contains('standup') || summary.contains('sync')) {
      return CalendarCategory.work;
    }

    // 6. Reminder
    if (summary.startsWith('remind') || summary.startsWith('todo')) {
      return CalendarCategory.reminder;
    }

    // Default to Personal for non-work calendars, otherwise Work/Meeting
    if (calendarId.toLowerCase().contains('personal')) return CalendarCategory.personal;

    return CalendarCategory.unknown;
  }
}
