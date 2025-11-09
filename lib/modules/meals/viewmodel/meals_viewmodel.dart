import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/firebase_service.dart';
import '../../home/viewmodel/home_viewmodel.dart';

class MealsViewModel extends GetxController {
  late final MealRepository _mealRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final _storage = GetStorage();

  RxList<MealModel> todaysMeals = <MealModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  // Get HomeViewModel to access family members
  HomeViewModel get _homeViewModel => Get.find<HomeViewModel>();

  // Get current user info
  UserModel? get currentUser {
    // TODO: Replace with actual current user from auth
    // For now, return a demo user
    return UserModel(
      id: 'demo_user_1',
      name: 'You',
      email: 'you@example.com',
      location: 'Current Location',
      status: 'home',
      isHome: true,
      lastSeen: DateTime.now(),
    );
  }

  // Get family members from HomeViewModel
  List<UserModel> get familyMembers => _homeViewModel.familyMembers;

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
      final allMeals = savedMeals
          .map((m) => _mealFromStorage(Map<String, dynamic>.from(m)))
          .toList();

      // Filter meals for selected date
      todaysMeals.value = _filterMealsByDate(allMeals, selectedDate.value);
      print(
        '✅ Loaded ${todaysMeals.length} saved meals for ${_formatDate(selectedDate.value)}',
      );
    }
  }

  void _saveMeals() {
    // Get all saved meals
    final savedMeals = _storage.read<List>('meals_data');
    List<MealModel> allMeals = [];

    if (savedMeals != null) {
      allMeals = savedMeals
          .map((m) => _mealFromStorage(Map<String, dynamic>.from(m)))
          .toList();
    }

    // Remove meals for current date
    allMeals.removeWhere(
      (m) =>
          m.date.year == selectedDate.value.year &&
          m.date.month == selectedDate.value.month &&
          m.date.day == selectedDate.value.day,
    );

    // Add current meals
    allMeals.addAll(todaysMeals);

    // Save all meals
    _storage.write(
      'meals_data',
      allMeals.map((m) => _mealToStorage(m)).toList(),
    );
    print('💾 Saved ${allMeals.length} total meals to storage');
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
      // Use Get.find since repository is registered in MainContainerBinding
      if (Get.isRegistered<MealRepository>()) {
        _mealRepository = Get.find<MealRepository>();
      } else {
        _mealRepository = Get.put(MealRepository());
      }
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
          '${userId}_${mealType}_${selectedDate.value.millisecondsSinceEpoch}';
      final newMeal = MealModel(
        id: mealId,
        userId: userId,
        userName: userName,
        mealType: mealType,
        isEaten: isEaten,
        date: selectedDate.value,
      );

      // Remove existing meal of same type for same user on selected date
      todaysMeals.removeWhere(
        (m) =>
            m.userId == userId &&
            m.mealType == mealType &&
            m.date.year == selectedDate.value.year &&
            m.date.month == selectedDate.value.month &&
            m.date.day == selectedDate.value.day,
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

  // Filter meals by date (same day)
  List<MealModel> _filterMealsByDate(List<MealModel> meals, DateTime date) {
    return meals.where((meal) {
      return meal.date.year == date.year &&
          meal.date.month == date.month &&
          meal.date.day == date.day;
    }).toList();
  }

  // Format date for display
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Change selected date
  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;

    // Load meals from storage for this date
    final savedMeals = _storage.read<List>('meals_data');
    if (savedMeals != null) {
      final allMeals = savedMeals
          .map((m) => _mealFromStorage(Map<String, dynamic>.from(m)))
          .toList();
      todaysMeals.value = _filterMealsByDate(allMeals, newDate);
    } else {
      todaysMeals.clear();
    }

    print(
      '📅 Changed date to ${_formatDate(newDate)}, showing ${todaysMeals.length} meals',
    );
  }

  // Check if date is today
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
