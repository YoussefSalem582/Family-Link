import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String? senderPhotoUrl;
  final String receiverId;
  final String text;
  final String? imageUrl;
  final String? voiceUrl;
  final String? documentUrl;
  final String? documentName;
  final int? documentSize;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final bool isRead;
  final MessageType type;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    this.senderPhotoUrl,
    required this.receiverId,
    required this.text,
    this.imageUrl,
    this.voiceUrl,
    this.documentUrl,
    this.documentName,
    this.documentSize,
    this.latitude,
    this.longitude,
    required this.createdAt,
    this.isRead = false,
    this.type = MessageType.text,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'documentUrl': documentUrl,
      'documentName': documentName,
      'documentSize': documentSize,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
      'type': type.toString(),
    };
  }

  // Create from JSON (for Firestore)
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      chatId: json['chatId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderPhotoUrl: json['senderPhotoUrl'],
      receiverId: json['receiverId'] ?? '',
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'],
      voiceUrl: json['voiceUrl'],
      documentUrl: json['documentUrl'],
      documentName: json['documentName'],
      documentSize: json['documentSize'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      isRead: json['isRead'] ?? false,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  // Create from Map (for GetStorage)
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? '',
      chatId: map['chatId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      senderPhotoUrl: map['senderPhotoUrl'],
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      imageUrl: map['imageUrl'],
      voiceUrl: map['voiceUrl'],
      documentUrl: map['documentUrl'],
      documentName: map['documentName'],
      documentSize: map['documentSize'],
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      isRead: map['isRead'] ?? false,
      type: MessageType.values.firstWhere(
        (e) => e.toString() == map['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  // Convert to Map (for GetStorage)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'senderName': senderName,
      'senderPhotoUrl': senderPhotoUrl,
      'receiverId': receiverId,
      'text': text,
      'imageUrl': imageUrl,
      'voiceUrl': voiceUrl,
      'documentUrl': documentUrl,
      'documentName': documentName,
      'documentSize': documentSize,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'type': type.toString(),
    };
  }

  // Copy with
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderName,
    String? senderPhotoUrl,
    String? receiverId,
    String? text,
    String? imageUrl,
    String? voiceUrl,
    String? documentUrl,
    String? documentName,
    int? documentSize,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    bool? isRead,
    MessageType? type,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderPhotoUrl: senderPhotoUrl ?? this.senderPhotoUrl,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      documentName: documentName ?? this.documentName,
      documentSize: documentSize ?? this.documentSize,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

enum MessageType { text, image, voice, document, location }
