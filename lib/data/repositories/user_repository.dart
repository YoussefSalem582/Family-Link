import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../../core/utils/constants.dart';

class UserRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all users (family members)
  Stream<List<UserModel>> getAllUsers() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Create user
  Future<bool> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toJson());
      return true;
    } catch (e) {
      print('Error creating user: $e');
      return false;
    }
  }

  // Update user
  Future<bool> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update(data);
      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Update user status (home/out/traveling)
  Future<bool> updateUserStatus(
    String userId,
    String status,
    bool isHome,
  ) async {
    return await updateUser(userId, {
      'status': status,
      'isHome': isHome,
      'lastSeen': Timestamp.now(),
    });
  }

  // Update user location
  Future<bool> updateUserLocation(
    String userId,
    double latitude,
    double longitude,
  ) async {
    return await updateUser(userId, {
      'latitude': latitude,
      'longitude': longitude,
      'lastSeen': Timestamp.now(),
    });
  }

  // Upload profile picture
  Future<String?> uploadProfilePicture(String userId, String filePath) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(File(filePath));
      final downloadUrl = await ref.getDownloadURL();

      // Update user profile with new photo URL
      await updateUser(userId, {'photoUrl': downloadUrl});

      return downloadUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting user: $e');
      return false;
    }
  }
}
