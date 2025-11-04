import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import '../models/post_model.dart';
import '../../core/utils/constants.dart';

class WallRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Get all wall posts
  Stream<List<PostModel>> getAllPosts() {
    return _firestore
        .collection(AppConstants.wallCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Get posts with pagination
  Future<List<PostModel>> getPostsPaginated(
    int limit,
    DocumentSnapshot? lastDocument,
  ) async {
    try {
      Query query = _firestore
          .collection(AppConstants.wallCollection)
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting posts: $e');
      return [];
    }
  }

  // Create text post
  Future<bool> createPost({
    required String userId,
    required String userName,
    String? userPhotoUrl,
    String? text,
  }) async {
    try {
      final postId = _firestore
          .collection(AppConstants.wallCollection)
          .doc()
          .id;

      final post = PostModel(
        id: postId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        text: text,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .set(post.toJson());

      return true;
    } catch (e) {
      print('Error creating post: $e');
      return false;
    }
  }

  // Create post with image
  Future<bool> createPostWithImage({
    required String userId,
    required String userName,
    String? userPhotoUrl,
    String? text,
    required String imagePath,
  }) async {
    try {
      // Upload image first
      final imageUrl = await _uploadImage(imagePath);
      if (imageUrl == null) return false;

      final postId = _firestore
          .collection(AppConstants.wallCollection)
          .doc()
          .id;

      final post = PostModel(
        id: postId,
        userId: userId,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        text: text,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .set(post.toJson());

      return true;
    } catch (e) {
      print('Error creating post with image: $e');
      return false;
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage(String filePath) async {
    try {
      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('wall_posts/$fileName');

      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Like/Unlike post
  Future<bool> toggleLike(String postId, String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .get();

      if (!doc.exists) return false;

      final post = PostModel.fromJson(doc.data()!);
      List<String> likes = List.from(post.likes);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .update({'likes': likes, 'likeCount': likes.length});

      return true;
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  // Delete post
  Future<bool> deletePost(String postId, String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .get();

      if (!doc.exists) return false;

      final post = PostModel.fromJson(doc.data()!);

      // Only post owner can delete
      if (post.userId != userId) return false;

      // Delete image from storage if exists
      if (post.imageUrl != null) {
        try {
          await FirebaseStorage.instance.refFromURL(post.imageUrl!).delete();
        } catch (e) {
          print('Error deleting image: $e');
        }
      }

      await _firestore
          .collection(AppConstants.wallCollection)
          .doc(postId)
          .delete();

      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }

  // Get user posts
  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection(AppConstants.wallCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => PostModel.fromJson(doc.data()))
              .toList(),
        );
  }
}
