import 'package:flutter/foundation.dart';
import 'upcoming_item.dart';

@immutable
class UpcomingState {
  const UpcomingState({required this.items, this.isLoading = false});

  final List<UpcomingItem> items;
  final bool isLoading;

  UpcomingState copyWith({List<UpcomingItem>? items, bool? isLoading}) {
    return UpcomingState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
