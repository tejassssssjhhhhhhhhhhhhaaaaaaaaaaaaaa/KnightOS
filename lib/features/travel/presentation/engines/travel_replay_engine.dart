import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/internal/storage/drift/knight_database.dart';

/// Presentation engine to handle Journey Replay logic.
/// Manages playback state, speed, and active segments.
class TravelReplayEngine extends ChangeNotifier {
  TravelReplayEngine({required this.trip, required this.bookings});

  final TripData trip;
  final List<TravelBookingData> bookings;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  double _progress = 0.0; // 0.0 to 1.0
  double get progress => _progress;

  double _playbackSpeed = 1.0;
  double get playbackSpeed => _playbackSpeed;

  int _currentBookingIndex = -1;
  int get currentBookingIndex => _currentBookingIndex;

  Timer? _timer;

  void play() {
    if (_isPlaying) return;
    _isPlaying = true;
    notifyListeners();
    
    _timer = Timer.periodic(Duration(milliseconds: (100 / _playbackSpeed).toInt()), (timer) {
      _progress += 0.01;
      if (_progress >= 1.0) {
        _progress = 1.0;
        pause();
      }
      _updateCurrentBooking();
      notifyListeners();
    });
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void setSpeed(double speed) {
    _playbackSpeed = speed;
    if (_isPlaying) {
      pause();
      play();
    } else {
      notifyListeners();
    }
  }

  void seek(double progress) {
    _progress = progress;
    _updateCurrentBooking();
    notifyListeners();
  }

  void _updateCurrentBooking() {
    if (bookings.isEmpty) return;
    final index = (_progress * (bookings.length - 1)).floor();
    if (index != _currentBookingIndex) {
      _currentBookingIndex = index;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
