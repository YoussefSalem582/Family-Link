import 'package:cloud_firestore/cloud_firestore.dart';

class MoodModel {
  final String id;
  final String userId;
  final String userName;
  final String mood; // happy, sad, excited, tired, etc.
  final String emoji;
  final String? note;
  final DateTime date;

  MoodModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.mood,
    required this.emoji,
    this.note,
    required this.date,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'mood': mood,
      'emoji': emoji,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }

  // Create from JSON
  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      mood: json['mood'] ?? '',
      emoji: json['emoji'] ?? '😊',
      note: json['note'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  // Copy with
  MoodModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? mood,
    String? emoji,
    String? note,
    DateTime? date,
  }) {
    return MoodModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      mood: mood ?? this.mood,
      emoji: emoji ?? this.emoji,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
