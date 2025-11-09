import 'package:flutter/material.dart';

/// Enum for different status types
enum StatusType {
  atHome,
  driving,
  atWork,
  atGym,
  shopping,
  atSchool,
  sleeping,
  availableToChat,
}

/// Model for user status with smart detection
class UserStatusModel {
  final String userId;
  final StatusType statusType;
  final String statusText;
  final String emoji;
  final DateTime updatedAt;
  final bool isAutoDetected;
  final bool doNotDisturb;
  final String? customMessage;
  final Map<String, dynamic>? location; // lat, lng, address

  UserStatusModel({
    required this.userId,
    required this.statusType,
    required this.statusText,
    required this.emoji,
    required this.updatedAt,
    this.isAutoDetected = false,
    this.doNotDisturb = false,
    this.customMessage,
    this.location,
  });

  /// Get status info from status type
  static Map<String, dynamic> getStatusInfo(StatusType type) {
    switch (type) {
      case StatusType.atHome:
        return {
          'emoji': '🏠',
          'text': 'At Home',
          'color': Colors.green,
          'dnd': false,
        };
      case StatusType.driving:
        return {
          'emoji': '🚗',
          'text': 'Driving',
          'color': Colors.blue,
          'dnd': true,
        };
      case StatusType.atWork:
        return {
          'emoji': '💼',
          'text': 'At Work',
          'color': Colors.orange,
          'dnd': false,
        };
      case StatusType.atGym:
        return {
          'emoji': '🏋️',
          'text': 'At Gym',
          'color': Colors.red,
          'dnd': false,
        };
      case StatusType.shopping:
        return {
          'emoji': '🛒',
          'text': 'Shopping',
          'color': Colors.purple,
          'dnd': false,
        };
      case StatusType.atSchool:
        return {
          'emoji': '🎓',
          'text': 'At School',
          'color': Colors.indigo,
          'dnd': false,
        };
      case StatusType.sleeping:
        return {
          'emoji': '😴',
          'text': 'Sleeping',
          'color': Colors.deepPurple,
          'dnd': true,
        };
      case StatusType.availableToChat:
        return {
          'emoji': '🎉',
          'text': 'Available to Chat',
          'color': Colors.teal,
          'dnd': false,
        };
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'statusType': statusType.toString(),
      'statusText': statusText,
      'emoji': emoji,
      'updatedAt': updatedAt.toIso8601String(),
      'isAutoDetected': isAutoDetected,
      'doNotDisturb': doNotDisturb,
      'customMessage': customMessage,
      'location': location,
    };
  }

  /// Create from JSON
  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
      userId: json['userId'] ?? '',
      statusType: StatusType.values.firstWhere(
        (e) => e.toString() == json['statusType'],
        orElse: () => StatusType.availableToChat,
      ),
      statusText: json['statusText'] ?? '',
      emoji: json['emoji'] ?? '🎉',
      updatedAt: DateTime.parse(json['updatedAt']),
      isAutoDetected: json['isAutoDetected'] ?? false,
      doNotDisturb: json['doNotDisturb'] ?? false,
      customMessage: json['customMessage'],
      location: json['location'],
    );
  }

  /// Copy with
  UserStatusModel copyWith({
    String? userId,
    StatusType? statusType,
    String? statusText,
    String? emoji,
    DateTime? updatedAt,
    bool? isAutoDetected,
    bool? doNotDisturb,
    String? customMessage,
    Map<String, dynamic>? location,
  }) {
    return UserStatusModel(
      userId: userId ?? this.userId,
      statusType: statusType ?? this.statusType,
      statusText: statusText ?? this.statusText,
      emoji: emoji ?? this.emoji,
      updatedAt: updatedAt ?? this.updatedAt,
      isAutoDetected: isAutoDetected ?? this.isAutoDetected,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      customMessage: customMessage ?? this.customMessage,
      location: location ?? this.location,
    );
  }
}
