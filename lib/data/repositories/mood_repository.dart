import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/mood_model.dart';
import '../../core/utils/constants.dart';

class MoodRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add mood
  Future<bool> addMood({
    required String userId,
    required String userName,
    required String mood,
    required String emoji,
    String? note,
  }) async {
    try {
      final moodId = '${userId}_${DateTime.now().millisecondsSinceEpoch}';

      final moodModel = MoodModel(
        id: moodId,
        userId: userId,
        userName: userName,
        mood: mood,
        emoji: emoji,
        note: note,
        date: DateTime.now(),
      );

      await _firestore
          .collection(AppConstants.moodsCollection)
          .doc(moodId)
          .set(moodModel.toJson());

      return true;
    } catch (e) {
      print('Error adding mood: $e');
      return false;
    }
  }

  // Get user moods for a date range
  Stream<List<MoodModel>> getUserMoods(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _firestore
        .collection(AppConstants.moodsCollection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MoodModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Get all family moods for today
  Stream<List<MoodModel>> getTodaysFamilyMoods() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.moodsCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MoodModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Get latest mood for a user
  Future<MoodModel?> getLatestUserMood(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.moodsCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return MoodModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting latest mood: $e');
      return null;
    }
  }

  // Get mood statistics
  Future<Map<String, int>> getMoodStatistics(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.moodsCollection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      final moods = snapshot.docs
          .map((doc) => MoodModel.fromJson(doc.data()))
          .toList();

      Map<String, int> moodCounts = {};
      for (var mood in moods) {
        moodCounts[mood.mood] = (moodCounts[mood.mood] ?? 0) + 1;
      }

      return moodCounts;
    } catch (e) {
      print('Error getting mood statistics: $e');
      return {};
    }
  }

  // Delete mood
  Future<bool> deleteMood(String moodId) async {
    try {
      await _firestore
          .collection(AppConstants.moodsCollection)
          .doc(moodId)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting mood: $e');
      return false;
    }
  }
}
