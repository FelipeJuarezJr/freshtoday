import 'package:flutter/foundation.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final DateTime startDate;
  final String? profilePicture;
  final List<String> goals;
  final Map<String, dynamic> preferences;
  final int currentStreak;
  final int longestStreak;
  final List<String> achievements;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.startDate,
    this.profilePicture,
    required this.goals,
    required this.preferences,
    required this.currentStreak,
    required this.longestStreak,
    required this.achievements,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      profilePicture: json['profilePicture'] as String?,
      goals: List<String>.from(json['goals'] as List),
      preferences: json['preferences'] as Map<String, dynamic>,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      achievements: List<String>.from(json['achievements'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'startDate': startDate.toIso8601String(),
      'profilePicture': profilePicture,
      'goals': goals,
      'preferences': preferences,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'achievements': achievements,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    DateTime? startDate,
    String? profilePicture,
    List<String>? goals,
    Map<String, dynamic>? preferences,
    int? currentStreak,
    int? longestStreak,
    List<String>? achievements,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      startDate: startDate ?? this.startDate,
      profilePicture: profilePicture ?? this.profilePicture,
      goals: goals ?? this.goals,
      preferences: preferences ?? this.preferences,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      achievements: achievements ?? this.achievements,
    );
  }
} 