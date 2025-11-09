import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final String? text;
  final String? imageUrl;
  final String? voiceUrl;
  final DateTime createdAt;
  final List<String> likes;
  final int likeCount;
  final int commentCount;
  final String?
  category; // For voice notes: bedtime_story, greeting, recipe, message, other
  final String? duration; // For voice notes: recording duration
  final String? title; // For voice notes: title/description

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    this.text,
    this.imageUrl,
    this.voiceUrl,
    required this.createdAt,
    this.likes = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.category,
    this.duration,
    this.title,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
      'text': text,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'likeCount': likeCount,
      'commentCount': commentCount,
      'category': category,
      'duration': duration,
      'title': title,
    };
  }

  // Create from JSON
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userPhotoUrl: json['userPhotoUrl'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(json['likes'] ?? []),
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      category: json['category'],
      duration: json['duration'],
      title: json['title'],
    );
  }

  // Copy with
  PostModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userPhotoUrl,
    String? text,
    String? imageUrl,
    String? voiceUrl,
    DateTime? createdAt,
    List<String>? likes,
    int? likeCount,
    int? commentCount,
    String? category,
    String? duration,
    String? title,
  }) {
    return PostModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userPhotoUrl: userPhotoUrl ?? this.userPhotoUrl,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      title: title ?? this.title,
    );
  }
}
