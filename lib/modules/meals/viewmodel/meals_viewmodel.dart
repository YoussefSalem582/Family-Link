import 'package:get/get.dart';
import '../../../data/models/meal_model.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/firebase_service.dart';

class MealsViewModel extends GetxController {
  late final MealRepository _mealRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  RxList<MealModel> todaysMeals = <MealModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    loadTodaysMeals();
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
      _loadDemoData();
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
          _loadDemoData();
        },
      );
    } catch (e) {
      print('Error in loadTodaysMeals: $e');
      _loadDemoData();
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
      print('Demo mode: Cannot update meal status');
      return;
    }
    await _mealRepository.updateMealStatus(
      userId: userId,
      userName: userName,
      mealType: mealType,
      isEaten: isEaten,
    );
  }

  List<MealModel> getMealsForUser(String userId) {
    return todaysMeals.where((meal) => meal.userId == userId).toList();
  }
}
