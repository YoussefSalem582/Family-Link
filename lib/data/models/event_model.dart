class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final EventType type;
  final String? userId; // For birthdays and personal events
  final String? userName; // For display
  final bool isRecurring; // For yearly events like birthdays

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    this.userId,
    this.userName,
    this.isRecurring = false,
  });

  // Check if event is upcoming (within next 7 days)
  bool get isUpcoming {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays >= 0 && difference.inDays <= 7;
  }

  // Check if event is today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Get days until event
  int get daysUntil {
    final now = DateTime.now();
    final difference = date.difference(now);
    return difference.inDays;
  }

  // Get event icon based on type
  String get icon {
    switch (type) {
      case EventType.birthday:
        return '🎂';
      case EventType.anniversary:
        return '💑';
      case EventType.holiday:
        return '🎉';
      case EventType.familyEvent:
        return '👨‍👩‍👧‍👦';
      case EventType.appointment:
        return '📅';
      case EventType.reminder:
        return '⏰';
      case EventType.other:
        return '📌';
    }
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'type': type.toString(),
      'userId': userId,
      'userName': userName,
      'isRecurring': isRecurring,
    };
  }

  // Create from JSON
  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      date: DateTime.parse(json['date'] as String),
      type: EventType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => EventType.other,
      ),
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
    );
  }

  // Copy with method
  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    EventType? type,
    String? userId,
    String? userName,
    bool? isRecurring,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      isRecurring: isRecurring ?? this.isRecurring,
    );
  }
}

enum EventType {
  birthday,
  anniversary,
  holiday,
  familyEvent,
  appointment,
  reminder,
  other,
}
