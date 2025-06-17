import 'package:flutter/foundation.dart';

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementType type;
  final int requiredValue;
  final DateTime? unlockedAt;
  final Map<String, dynamic>? metadata;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.requiredValue,
    this.unlockedAt,
    this.metadata,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      type: AchievementType.values.firstWhere(
        (e) => e.toString() == 'AchievementType.${json['type']}',
      ),
      requiredValue: json['requiredValue'] as int,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type.toString().split('.').last,
      'requiredValue': requiredValue,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementType? type,
    int? requiredValue,
    DateTime? unlockedAt,
    Map<String, dynamic>? metadata,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      requiredValue: requiredValue ?? this.requiredValue,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

enum AchievementType {
  daysSober,
  streakDays,
  checkIns,
  communityPosts,
  goalsCompleted,
  moneySaved,
  custom
}

class MilestoneModel {
  final String id;
  final String title;
  final String description;
  final int daysRequired;
  final String icon;
  final DateTime? achievedAt;
  final Map<String, dynamic>? rewards;

  MilestoneModel({
    required this.id,
    required this.title,
    required this.description,
    required this.daysRequired,
    required this.icon,
    this.achievedAt,
    this.rewards,
  });

  factory MilestoneModel.fromJson(Map<String, dynamic> json) {
    return MilestoneModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      daysRequired: json['daysRequired'] as int,
      icon: json['icon'] as String,
      achievedAt: json['achievedAt'] != null
          ? DateTime.parse(json['achievedAt'] as String)
          : null,
      rewards: json['rewards'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'daysRequired': daysRequired,
      'icon': icon,
      'achievedAt': achievedAt?.toIso8601String(),
      'rewards': rewards,
    };
  }

  MilestoneModel copyWith({
    String? id,
    String? title,
    String? description,
    int? daysRequired,
    String? icon,
    DateTime? achievedAt,
    Map<String, dynamic>? rewards,
  }) {
    return MilestoneModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      daysRequired: daysRequired ?? this.daysRequired,
      icon: icon ?? this.icon,
      achievedAt: achievedAt ?? this.achievedAt,
      rewards: rewards ?? this.rewards,
    );
  }
} 