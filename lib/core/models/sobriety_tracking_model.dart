import 'package:flutter/foundation.dart';

class SobrietyTrackingModel {
  final String id;
  final String userId;
  final DateTime startDate;
  final DateTime? lastCheckIn;
  final int totalDays;
  final int currentStreak;
  final int longestStreak;
  final List<CheckIn> checkIns;
  final Map<String, dynamic> statistics;

  SobrietyTrackingModel({
    required this.id,
    required this.userId,
    required this.startDate,
    this.lastCheckIn,
    required this.totalDays,
    required this.currentStreak,
    required this.longestStreak,
    required this.checkIns,
    required this.statistics,
  });

  factory SobrietyTrackingModel.fromJson(Map<String, dynamic> json) {
    return SobrietyTrackingModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.parse(json['lastCheckIn'] as String)
          : null,
      totalDays: json['totalDays'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      checkIns: (json['checkIns'] as List)
          .map((e) => CheckIn.fromJson(e as Map<String, dynamic>))
          .toList(),
      statistics: json['statistics'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'lastCheckIn': lastCheckIn?.toIso8601String(),
      'totalDays': totalDays,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'checkIns': checkIns.map((e) => e.toJson()).toList(),
      'statistics': statistics,
    };
  }

  SobrietyTrackingModel copyWith({
    String? id,
    String? userId,
    DateTime? startDate,
    DateTime? lastCheckIn,
    int? totalDays,
    int? currentStreak,
    int? longestStreak,
    List<CheckIn>? checkIns,
    Map<String, dynamic>? statistics,
  }) {
    return SobrietyTrackingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      lastCheckIn: lastCheckIn ?? this.lastCheckIn,
      totalDays: totalDays ?? this.totalDays,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      checkIns: checkIns ?? this.checkIns,
      statistics: statistics ?? this.statistics,
    );
  }
}

class CheckIn {
  final String id;
  final DateTime date;
  final String mood;
  final String note;
  final List<String> triggers;
  final List<String> copingStrategies;

  CheckIn({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
    required this.triggers,
    required this.copingStrategies,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as String,
      note: json['note'] as String,
      triggers: List<String>.from(json['triggers'] as List),
      copingStrategies: List<String>.from(json['copingStrategies'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'mood': mood,
      'note': note,
      'triggers': triggers,
      'copingStrategies': copingStrategies,
    };
  }
} 