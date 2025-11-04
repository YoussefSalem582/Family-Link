import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String location; // Country/City
  final String status; // home, out, traveling
  final bool isHome;
  final double? latitude;
  final double? longitude;
  final DateTime? lastSeen;
  final String? fcmToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.location,
    this.status = 'out',
    this.isHome = false,
    this.latitude,
    this.longitude,
    this.lastSeen,
    this.fcmToken,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'location': location,
      'status': status,
      'isHome': isHome,
      'latitude': latitude,
      'longitude': longitude,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'fcmToken': fcmToken,
    };
  }

  // Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      photoUrl: json['photoUrl'],
      location: json['location'] ?? '',
      status: json['status'] ?? 'out',
      isHome: json['isHome'] ?? false,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      lastSeen: json['lastSeen'] != null
          ? (json['lastSeen'] as Timestamp).toDate()
          : null,
      fcmToken: json['fcmToken'],
    );
  }

  // Copy with
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? location,
    String? status,
    bool? isHome,
    double? latitude,
    double? longitude,
    DateTime? lastSeen,
    String? fcmToken,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      location: location ?? this.location,
      status: status ?? this.status,
      isHome: isHome ?? this.isHome,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastSeen: lastSeen ?? this.lastSeen,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }
}
