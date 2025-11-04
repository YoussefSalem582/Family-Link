import 'package:cloud_firestore/cloud_firestore.dart';

class MealModel {
  final String id;
  final String userId;
  final String userName;
  final String mealType; // breakfast, lunch, dinner
  final bool isEaten;
  final DateTime date;
  final String? notes;

  MealModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.mealType,
    required this.isEaten,
    required this.date,
    this.notes,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'mealType': mealType,
      'isEaten': isEaten,
      'date': Timestamp.fromDate(date),
      'notes': notes,
    };
  }

  // Create from JSON
  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      mealType: json['mealType'] ?? '',
      isEaten: json['isEaten'] ?? false,
      date: (json['date'] as Timestamp).toDate(),
      notes: json['notes'],
    );
  }

  // Copy with
  MealModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? mealType,
    bool? isEaten,
    DateTime? date,
    String? notes,
  }) {
    return MealModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      mealType: mealType ?? this.mealType,
      isEaten: isEaten ?? this.isEaten,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}
