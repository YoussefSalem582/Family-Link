import 'package:flutter/material.dart';

/// Model for calendar availability slot
class AvailabilitySlot {
  final String id;
  final DateTime start;
  final DateTime end;
  final String userId;
  final String userName;
  final bool isFree;
  final String? activityName;
  final bool familyWelcome; // Can family join this activity?
  final Color? color;
  final String? location;
  final String? description;

  AvailabilitySlot({
    required this.id,
    required this.start,
    required this.end,
    required this.userId,
    required this.userName,
    this.isFree = true,
    this.activityName,
    this.familyWelcome = false,
    this.color,
    this.location,
    this.description,
  });

  /// Duration of the slot
  Duration get duration => end.difference(start);

  /// Is this slot happening today?
  bool get isToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final slotDay = DateTime(start.year, start.month, start.day);
    return today == slotDay;
  }

  /// Is this slot currently active?
  bool get isActive {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'userId': userId,
      'userName': userName,
      'isFree': isFree,
      'activityName': activityName,
      'familyWelcome': familyWelcome,
      'color': color?.value,
      'location': location,
      'description': description,
    };
  }

  /// Create from JSON
  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      id: json['id'] ?? '',
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      isFree: json['isFree'] ?? true,
      activityName: json['activityName'],
      familyWelcome: json['familyWelcome'] ?? false,
      color: json['color'] != null ? Color(json['color']) : null,
      location: json['location'],
      description: json['description'],
    );
  }

  /// Copy with
  AvailabilitySlot copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    String? userId,
    String? userName,
    bool? isFree,
    String? activityName,
    bool? familyWelcome,
    Color? color,
    String? location,
    String? description,
  }) {
    return AvailabilitySlot(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isFree: isFree ?? this.isFree,
      activityName: activityName ?? this.activityName,
      familyWelcome: familyWelcome ?? this.familyWelcome,
      color: color ?? this.color,
      location: location ?? this.location,
      description: description ?? this.description,
    );
  }
}

/// Model for common free time slot (when multiple family members are free)
class CommonFreeSlot {
  final String id;
  final DateTime start;
  final DateTime end;
  final List<String> availableMembers; // User IDs who are free
  final List<String> availableMemberNames; // User names
  final int totalMembers;

  CommonFreeSlot({
    required this.id,
    required this.start,
    required this.end,
    required this.availableMembers,
    required this.availableMemberNames,
    required this.totalMembers,
  });

  /// How many members are available
  int get availableCount => availableMembers.length;

  /// Percentage of family available
  double get availabilityPercentage =>
      (availableMembers.length / totalMembers * 100);

  /// Duration of common free time
  Duration get duration => end.difference(start);

  /// Is everyone available?
  bool get isEveryoneAvailable => availableMembers.length == totalMembers;

  /// Quality score (higher is better for scheduling)
  double get qualityScore {
    final percentageScore = availabilityPercentage / 100;
    final durationScore = (duration.inMinutes / 180).clamp(
      0.0,
      1.0,
    ); // Max 3 hours
    return (percentageScore * 0.7) + (durationScore * 0.3);
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'availableMembers': availableMembers,
      'availableMemberNames': availableMemberNames,
      'totalMembers': totalMembers,
    };
  }

  /// Create from JSON
  factory CommonFreeSlot.fromJson(Map<String, dynamic> json) {
    return CommonFreeSlot(
      id: json['id'] ?? '',
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
      availableMembers: List<String>.from(json['availableMembers'] ?? []),
      availableMemberNames: List<String>.from(
        json['availableMemberNames'] ?? [],
      ),
      totalMembers: json['totalMembers'] ?? 0,
    );
  }
}

/// Model for family event suggestion
class FamilyEventSuggestion {
  final String id;
  final String title;
  final String emoji;
  final CommonFreeSlot timeSlot;
  final String? description;
  final String category; // dinner, movie, game, outdoor, etc.
  final int priority; // 1-5, 5 being highest

  FamilyEventSuggestion({
    required this.id,
    required this.title,
    required this.emoji,
    required this.timeSlot,
    this.description,
    this.category = 'general',
    this.priority = 3,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'emoji': emoji,
      'timeSlot': timeSlot.toJson(),
      'description': description,
      'category': category,
      'priority': priority,
    };
  }

  /// Create from JSON
  factory FamilyEventSuggestion.fromJson(Map<String, dynamic> json) {
    return FamilyEventSuggestion(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      emoji: json['emoji'] ?? '📅',
      timeSlot: CommonFreeSlot.fromJson(json['timeSlot']),
      description: json['description'],
      category: json['category'] ?? 'general',
      priority: json['priority'] ?? 3,
    );
  }
}

/// Event category templates for suggestions
class EventCategory {
  final String name;
  final String emoji;
  final List<String> titles;
  final TimePreference timePreference;

  EventCategory({
    required this.name,
    required this.emoji,
    required this.titles,
    required this.timePreference,
  });

  static final List<EventCategory> categories = [
    EventCategory(
      name: 'dinner',
      emoji: '🍽️',
      titles: ['Family Dinner', 'Dinner Together', 'Evening Meal'],
      timePreference: TimePreference.evening,
    ),
    EventCategory(
      name: 'movie',
      emoji: '🎬',
      titles: ['Movie Night', 'Watch Together', 'Cinema Time'],
      timePreference: TimePreference.evening,
    ),
    EventCategory(
      name: 'game',
      emoji: '🎮',
      titles: ['Game Night', 'Board Games', 'Family Game Time'],
      timePreference: TimePreference.evening,
    ),
    EventCategory(
      name: 'outdoor',
      emoji: '🌳',
      titles: ['Outdoor Activity', 'Park Visit', 'Nature Walk'],
      timePreference: TimePreference.afternoon,
    ),
    EventCategory(
      name: 'sport',
      emoji: '⚽',
      titles: ['Sports Activity', 'Play Together', 'Exercise Time'],
      timePreference: TimePreference.afternoon,
    ),
    EventCategory(
      name: 'breakfast',
      emoji: '🥞',
      titles: ['Family Breakfast', 'Breakfast Together', 'Morning Meal'],
      timePreference: TimePreference.morning,
    ),
  ];
}

/// Time preference for event categories
enum TimePreference {
  morning, // 6 AM - 11 AM
  afternoon, // 12 PM - 5 PM
  evening, // 6 PM - 10 PM
  anytime,
}
