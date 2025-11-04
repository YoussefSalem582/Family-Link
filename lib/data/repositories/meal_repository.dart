import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/meal_model.dart';
import '../../core/utils/constants.dart';

class MealRepository extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get meals for a specific date
  Stream<List<MealModel>> getMealsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.mealsCollection)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Get user meals for a date range
  Stream<List<MealModel>> getUserMeals(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _firestore
        .collection(AppConstants.mealsCollection)
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MealModel.fromJson(doc.data()))
              .toList(),
        );
  }

  // Add or update meal status
  Future<bool> updateMealStatus({
    required String userId,
    required String userName,
    required String mealType,
    required bool isEaten,
    String? notes,
  }) async {
    try {
      final today = DateTime.now();
      final mealId =
          '${userId}_${mealType}_${today.year}${today.month}${today.day}';

      final meal = MealModel(
        id: mealId,
        userId: userId,
        userName: userName,
        mealType: mealType,
        isEaten: isEaten,
        date: today,
        notes: notes,
      );

      await _firestore
          .collection(AppConstants.mealsCollection)
          .doc(mealId)
          .set(meal.toJson());

      return true;
    } catch (e) {
      print('Error updating meal status: $e');
      return false;
    }
  }

  // Get today's meals for all family members
  Stream<List<MealModel>> getTodaysMeals() {
    return getMealsByDate(DateTime.now());
  }

  // Get meal statistics
  Future<Map<String, dynamic>> getMealStatistics(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.mealsCollection)
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
          .get();

      final meals = snapshot.docs
          .map((doc) => MealModel.fromJson(doc.data()))
          .toList();

      int totalMeals = meals.length;
      int eatenMeals = meals.where((meal) => meal.isEaten).length;
      int skippedMeals = totalMeals - eatenMeals;

      Map<String, int> mealTypeCounts = {};
      for (var meal in meals) {
        if (meal.isEaten) {
          mealTypeCounts[meal.mealType] =
              (mealTypeCounts[meal.mealType] ?? 0) + 1;
        }
      }

      return {
        'total': totalMeals,
        'eaten': eatenMeals,
        'skipped': skippedMeals,
        'percentage': totalMeals > 0
            ? (eatenMeals / totalMeals * 100).round()
            : 0,
        'byType': mealTypeCounts,
      };
    } catch (e) {
      print('Error getting meal statistics: $e');
      return {};
    }
  }
}
