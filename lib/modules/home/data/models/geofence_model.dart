/// Model for geofencing location
class GeofenceLocation {
  final String id;
  final String name;
  final String emoji;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final bool notifyOnArrival;
  final bool notifyOnDeparture;
  final String? address;

  GeofenceLocation({
    required this.id,
    required this.name,
    required this.emoji,
    required this.latitude,
    required this.longitude,
    this.radiusMeters = 100.0, // 100 meters default radius
    this.notifyOnArrival = true,
    this.notifyOnDeparture = true,
    this.address,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'notifyOnArrival': notifyOnArrival,
      'notifyOnDeparture': notifyOnDeparture,
      'address': address,
    };
  }

  /// Create from JSON
  factory GeofenceLocation.fromJson(Map<String, dynamic> json) {
    return GeofenceLocation(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      emoji: json['emoji'] ?? '📍',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      radiusMeters: json['radiusMeters']?.toDouble() ?? 100.0,
      notifyOnArrival: json['notifyOnArrival'] ?? true,
      notifyOnDeparture: json['notifyOnDeparture'] ?? true,
      address: json['address'],
    );
  }

  /// Copy with
  GeofenceLocation copyWith({
    String? id,
    String? name,
    String? emoji,
    double? latitude,
    double? longitude,
    double? radiusMeters,
    bool? notifyOnArrival,
    bool? notifyOnDeparture,
    String? address,
  }) {
    return GeofenceLocation(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      notifyOnArrival: notifyOnArrival ?? this.notifyOnArrival,
      notifyOnDeparture: notifyOnDeparture ?? this.notifyOnDeparture,
      address: address ?? this.address,
    );
  }
}

/// Model for arrival/departure notification
class LocationNotification {
  final String userId;
  final String userName;
  final GeofenceLocation location;
  final bool isArrival; // true for arrival, false for departure
  final DateTime timestamp;
  final int? estimatedMinutes; // For departure notifications

  LocationNotification({
    required this.userId,
    required this.userName,
    required this.location,
    required this.isArrival,
    required this.timestamp,
    this.estimatedMinutes,
  });

  /// Get notification message
  String get message {
    if (isArrival) {
      return '$userName just arrived at ${location.emoji} ${location.name}!';
    } else {
      if (estimatedMinutes != null) {
        return '$userName left ${location.emoji} ${location.name}, ETA $estimatedMinutes minutes';
      }
      return '$userName left ${location.emoji} ${location.name}';
    }
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'location': location.toJson(),
      'isArrival': isArrival,
      'timestamp': timestamp.toIso8601String(),
      'estimatedMinutes': estimatedMinutes,
    };
  }

  /// Create from JSON
  factory LocationNotification.fromJson(Map<String, dynamic> json) {
    return LocationNotification(
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      location: GeofenceLocation.fromJson(json['location']),
      isArrival: json['isArrival'] ?? true,
      timestamp: DateTime.parse(json['timestamp']),
      estimatedMinutes: json['estimatedMinutes'],
    );
  }
}
