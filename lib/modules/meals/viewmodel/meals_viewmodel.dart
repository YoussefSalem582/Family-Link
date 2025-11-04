import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/firebase_service.dart';

class MealsViewModel extends GetxController {
  late final MealRepository _mealRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final _storage = GetStorage();

  RxList<MealModel> todaysMeals = <MealModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _loadSavedMeals();
    loadTodaysMeals();
  }

  void _loadSavedMeals() {
    final savedMeals = _storage.read<List>('meals_data');
    if (savedMeals != null) {
      todaysMeals.value = savedMeals
          .map((m) => _mealFromStorage(Map<String, dynamic>.from(m)))
          .toList();
    }
  }

  void _saveMeals() {
    _storage.write(
      'meals_data',
      todaysMeals.map((m) => _mealToStorage(m)).toList(),
    );
  }

  // Storage serialization helpers
  Map<String, dynamic> _mealToStorage(MealModel meal) {
    return {
      'id': meal.id,
      'userId': meal.userId,
      'userName': meal.userName,
      'mealType': meal.mealType,
      'isEaten': meal.isEaten,
      'date': meal.date.toIso8601String(),
      'notes': meal.notes,
    };
  }

  MealModel _mealFromStorage(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      mealType: json['mealType'] ?? '',
      isEaten: json['isEaten'] ?? false,
      date: DateTime.parse(json['date']),
      notes: json['notes'],
    );
  }

  void _initializeRepository() {
    try {
      _mealRepository = Get.put(MealRepository());
    } catch (e) {
      print('⚠️ Repository initialization failed, using demo mode');
      isDemoMode.value = true;
    }
  }

  void loadTodaysMeals() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      // In demo mode, don't reload demo data if we already have meals
      if (todaysMeals.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
      return;
    }

    try {
      _mealRepository.getTodaysMeals().listen(
        (meals) {
          todaysMeals.value = meals;
          isLoading.value = false;
        },
        onError: (error) {
          print('Error loading meals: $error');
          if (todaysMeals.isEmpty) {
            _loadDemoData();
          } else {
            isLoading.value = false;
          }
        },
      );
    } catch (e) {
      print('Error in loadTodaysMeals: $e');
      if (todaysMeals.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
    }
  }

  void _loadDemoData() {
    final today = DateTime.now();
    todaysMeals.value = [
      MealModel(
        id: '1',
        userId: '1',
        userName: 'Ahmed',
        mealType: AppConstants.breakfast,
        isEaten: true,
        date: today,
      ),
      MealModel(
        id: '2',
        userId: '2',
        userName: 'Fatima',
        mealType: AppConstants.breakfast,
        isEaten: true,
        date: today,
      ),
      MealModel(
        id: '3',
        userId: '2',
        userName: 'Fatima',
        mealType: AppConstants.lunch,
        isEaten: true,
        date: today,
      ),
      MealModel(
        id: '4',
        userId: '3',
        userName: 'Omar',
        mealType: AppConstants.breakfast,
        isEaten: false,
        date: today,
      ),
    ];
    isLoading.value = false;
    isDemoMode.value = true;
  }

  Future<void> updateMealStatus(
    String userId,
    String userName,
    String mealType,
    bool isEaten,
  ) async {
    if (isDemoMode.value) {
      // In demo mode, update meal status locally
      final mealId =
          '${userId}_${mealType}_${DateTime.now().millisecondsSinceEpoch}';
      final newMeal = MealModel(
        id: mealId,
        userId: userId,
        userName: userName,
        mealType: mealType,
        isEaten: isEaten,
        date: DateTime.now(),
      );

      // Remove existing meal of same type for same user today
      todaysMeals.removeWhere(
        (m) =>
            m.userId == userId &&
            m.mealType == mealType &&
            m.date.day == DateTime.now().day,
      );

      todaysMeals.insert(0, newMeal);
      todaysMeals.refresh();
      _saveMeals(); // Save to storage

      Get.snackbar(
        'success'.tr,
        'meals_meal_added'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      final success = await _mealRepository.updateMealStatus(
        userId: userId,
        userName: userName,
        mealType: mealType,
        isEaten: isEaten,
      );

      if (success) {
        Get.snackbar(
          'success'.tr,
          'meals_meal_added'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to update meal status',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  List<MealModel> getMealsForUser(String userId) {
    return todaysMeals.where((meal) => meal.userId == userId).toList();
  }
}
