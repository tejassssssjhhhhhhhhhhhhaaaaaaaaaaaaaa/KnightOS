import 'package:flutter_test/flutter_test.dart';
import 'package:knight_os/core/logic/engine/insight_engine.dart';
import 'package:knight_os/core/logic/engine/knight_score_engine.dart';
import 'package:knight_os/core/logic/engine/mission_engine.dart';
import 'package:knight_os/core/logic/engine/recommendation_engine.dart';
import 'package:knight_os/core/logic/engine/streak_engine.dart';
import 'package:knight_os/core/logic/engine/timeline_engine.dart';
import 'package:knight_os/features/onboarding/domain/onboarding_profile.dart';
import 'package:knight_os/features/work_tracker/domain/work_session.dart';

void main() {
  group('KnightScoreEngine', () {
    test('creates a bounded score with a detailed breakdown', () {
      final engine = KnightScoreEngine();
      final result = engine.calculateScore(
        profile: UserProfile(completedSteps: const ['profile', 'health']),
        sessions: [
          WorkSession(
            id: '1',
            workDate: '2026-07-23',
            startTime: '09:00',
            endTime: '17:00',
            shiftType: 'Night',
            questionsCompleted: 40,
            callsHandled: 20,
            chatsHandled: 10,
            breakDuration: 15,
            focusRating: 8,
            stressRating: 6,
            energyRating: 7,
            notes: '',
            totalHours: 8,
            productiveHours: 7,
            callsPercentage: 50,
            chatsPercentage: 25,
            questionsPerHour: 5,
            weeklyAverage: 4,
            monthlyAverage: 3,
          ),
        ],
      );

      expect(result.score, inInclusiveRange(0, 100));
      expect(result.scoreLabel, isNotEmpty);
      expect(result.scoreColor, isNotEmpty);
      expect(
        result.scoreBreakdown.keys,
        containsAll(['Work Productivity', 'Profile Completion']),
      );
    });
  });

  group('InsightEngine', () {
    test('generates local insights for profile and work signals', () {
      final engine = InsightEngine();
      final insights = engine.generateInsights(
        profile: UserProfile(completedSteps: const ['profile']),
        sessions: [
          WorkSession(
            id: '1',
            workDate: '2026-07-23',
            startTime: '09:00',
            endTime: '17:00',
            shiftType: 'Night',
            questionsCompleted: 40,
            callsHandled: 20,
            chatsHandled: 10,
            breakDuration: 15,
            focusRating: 3,
            stressRating: 8,
            energyRating: 5,
            notes: '',
            totalHours: 8,
            productiveHours: 5,
            callsPercentage: 50,
            chatsPercentage: 25,
            questionsPerHour: 5,
            weeklyAverage: 4,
            monthlyAverage: 3,
          ),
        ],
      );

      expect(insights, contains('Night Shift detected'));
      expect(insights, contains('High Stress detected'));
      expect(insights, contains('Low Focus'));
      expect(insights, contains('Profile incomplete'));
    });
  });

  group('RecommendationEngine', () {
    test('returns actionable recommendations', () {
      final engine = RecommendationEngine();
      final recommendations = engine.generateRecommendations(
        score: 64,
        profile: UserProfile(completedSteps: const ['profile']),
        sessions: const [],
      );

      expect(recommendations, isNotEmpty);
      expect(
        recommendations.any(
          (item) =>
              item.contains('break') ||
              item.contains('profile') ||
              item.contains('workout'),
        ),
        isTrue,
      );
    });
  });

  group('MissionEngine', () {
    test('builds a mission for the day', () {
      final engine = MissionEngine();
      final mission = engine.generateMission(
        profile: UserProfile(completedSteps: const ['profile', 'health']),
        sessions: const [],
      );

      expect(mission, isNotEmpty);
      expect(mission.toLowerCase(), contains('today'));
    });
  });

  group('TimelineEngine', () {
    test('builds a unified timeline from profile and work data', () {
      final engine = TimelineEngine();
      final timeline = engine.buildTimeline(
        profile: UserProfile(completedSteps: const ['profile', 'health']),
        sessions: [
          WorkSession(
            id: '1',
            workDate: '2026-07-23',
            startTime: '09:00',
            endTime: '17:00',
            shiftType: 'Day',
            questionsCompleted: 40,
            callsHandled: 20,
            chatsHandled: 10,
            breakDuration: 15,
            focusRating: 8,
            stressRating: 6,
            energyRating: 7,
            notes: '',
            totalHours: 8,
            productiveHours: 7,
            callsPercentage: 50,
            chatsPercentage: 25,
            questionsPerHour: 5,
            weeklyAverage: 4,
            monthlyAverage: 3,
          ),
        ],
      );

      expect(timeline, isNotEmpty);
      expect(timeline.any((item) => item.type == 'profile_updated'), isTrue);
      expect(timeline.any((item) => item.type == 'work_logged'), isTrue);
    });
  });

  group('StreakEngine', () {
    test('calculates streak metrics from active dates', () {
      final engine = StreakEngine();
      final summary = engine.calculateStreak(
        activeDates: [
          DateTime(2026, 7, 20),
          DateTime(2026, 7, 21),
          DateTime(2026, 7, 22),
          DateTime(2026, 7, 24),
        ],
        now: DateTime(2026, 7, 24),
      );

      expect(summary.currentStreak, 2);
      expect(summary.longestStreak, 3);
      expect(summary.lastActive, DateTime(2026, 7, 24));
      expect(summary.daysMissed, 1);
    });
  });
}
