import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/sobriety_tracking_model.dart';
import '../models/achievement_model.dart';

class SobrietyService {
  final SharedPreferences _prefs;
  static const String _startDateKey = 'sobriety_start_date';
  static const String _lastCheckInKey = 'last_check_in';
  static const String _currentStreakKey = 'current_streak';
  static const String _longestStreakKey = 'longest_streak';

  SobrietyService(this._prefs);

  Future<void> startSobrietyJourney() async {
    final now = DateTime.now();
    await _prefs.setString(_startDateKey, now.toIso8601String());
    await _prefs.setInt(_currentStreakKey, 0);
    await _prefs.setInt(_longestStreakKey, 0);
  }

  Future<void> checkIn(CheckIn checkIn) async {
    final lastCheckIn = _prefs.getString(_lastCheckInKey);
    final currentStreak = _prefs.getInt(_currentStreakKey) ?? 0;
    final longestStreak = _prefs.getInt(_longestStreakKey) ?? 0;

    if (lastCheckIn != null) {
      final lastCheckInDate = DateTime.parse(lastCheckIn);
      final difference = checkIn.date.difference(lastCheckInDate).inDays;

      if (difference == 1) {
        // Consecutive day
        final newStreak = currentStreak + 1;
        await _prefs.setInt(_currentStreakKey, newStreak);
        if (newStreak > longestStreak) {
          await _prefs.setInt(_longestStreakKey, newStreak);
        }
      } else if (difference > 1) {
        // Streak broken
        await _prefs.setInt(_currentStreakKey, 0);
      }
    }

    await _prefs.setString(_lastCheckInKey, checkIn.date.toIso8601String());
  }

  Future<SobrietyTrackingModel> getSobrietyStatus() async {
    final startDate = _prefs.getString(_startDateKey);
    final lastCheckIn = _prefs.getString(_lastCheckInKey);
    final currentStreak = _prefs.getInt(_currentStreakKey) ?? 0;
    final longestStreak = _prefs.getInt(_longestStreakKey) ?? 0;

    if (startDate == null) {
      throw Exception('Sobriety journey has not started');
    }

    final startDateTime = DateTime.parse(startDate);
    final totalDays = DateTime.now().difference(startDateTime).inDays;

    return SobrietyTrackingModel(
      id: 'current',
      userId: 'current_user', // This should be replaced with actual user ID
      startDate: startDateTime,
      lastCheckIn: lastCheckIn != null ? DateTime.parse(lastCheckIn) : null,
      totalDays: totalDays,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      checkIns: [], // This should be populated from a database
      statistics: {
        'moneySaved': calculateMoneySaved(totalDays),
        'timeRegained': calculateTimeRegained(totalDays),
        'healthBenefits': getHealthBenefits(totalDays),
      },
    );
  }

  double calculateMoneySaved(int days) {
    // This is a placeholder calculation. The actual calculation should be based on user's input
    const double dailySpending = 20.0; // Example: $20 per day
    return days * dailySpending;
  }

  double calculateTimeRegained(int days) {
    // This is a placeholder calculation. The actual calculation should be based on user's input
    const double dailyHours = 4.0; // Example: 4 hours per day
    return days * dailyHours;
  }

  List<String> getHealthBenefits(int days) {
    final benefits = <String>[];
    
    if (days >= 1) {
      benefits.add('Blood pressure begins to normalize');
    }
    if (days >= 2) {
      benefits.add('Sense of smell and taste improve');
    }
    if (days >= 3) {
      benefits.add('Energy levels increase');
    }
    if (days >= 7) {
      benefits.add('Sleep quality improves');
    }
    if (days >= 30) {
      benefits.add('Liver function improves');
    }
    if (days >= 90) {
      benefits.add('Risk of heart disease decreases');
    }
    if (days >= 180) {
      benefits.add('Immune system strengthens');
    }
    if (days >= 365) {
      benefits.add('Risk of cancer decreases');
    }

    return benefits;
  }

  List<MilestoneModel> getMilestones() {
    return [
      MilestoneModel(
        id: '1_day',
        title: 'First Day',
        description: 'Congratulations on completing your first day!',
        daysRequired: 1,
        icon: '🎉',
      ),
      MilestoneModel(
        id: '1_week',
        title: 'One Week',
        description: 'You\'ve made it through your first week!',
        daysRequired: 7,
        icon: '🌟',
      ),
      MilestoneModel(
        id: '1_month',
        title: 'One Month',
        description: 'A month of sobriety! You\'re doing great!',
        daysRequired: 30,
        icon: '🏆',
      ),
      MilestoneModel(
        id: '3_months',
        title: 'Three Months',
        description: 'Quarter of a year! Your dedication is inspiring!',
        daysRequired: 90,
        icon: '💫',
      ),
      MilestoneModel(
        id: '6_months',
        title: 'Six Months',
        description: 'Half a year of sobriety! Incredible achievement!',
        daysRequired: 180,
        icon: '🎯',
      ),
      MilestoneModel(
        id: '1_year',
        title: 'One Year',
        description: 'A full year of sobriety! You\'re amazing!',
        daysRequired: 365,
        icon: '👑',
      ),
    ];
  }
} 