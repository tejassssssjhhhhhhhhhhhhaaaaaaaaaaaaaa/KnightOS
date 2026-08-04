import 'package:flutter/material.dart';

enum ActivityType { transaction, health, timeline, task, import }

class ActivityItem {
  final ActivityType type;
  final String id;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final dynamic originalData;
  final IconData icon;
  final Color color;

  const ActivityItem({
    required this.type,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.originalData,
  });
}
