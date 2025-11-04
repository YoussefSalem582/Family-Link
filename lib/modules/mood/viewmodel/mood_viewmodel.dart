import 'package:get/get.dart';
import '../../../data/models/mood_model.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/firebase_service.dart';

class MoodViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  late MoodRepository _moodRepository;

  RxList<MoodModel> todaysMoods = <MoodModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  Rx<String> selectedMood = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
  }

  void _initializeRepository() {
    try {
      if (!_firebaseService.isInitialized) {
        isDemoMode.value = true;
        _loadDemoData();
        return;
      }
      _moodRepository = Get.put(MoodRepository());
      loadTodaysMoods();
    } catch (e) {
      print('Error initializing mood repository: $e');
      isDemoMode.value = true;
      _loadDemoData();
    }
  }

  void _loadDemoData() {
    final now = DateTime.now();
    todaysMoods.value = [
      MoodModel(
        id: 'demo1',
        userId: 'user1',
        userName: 'Ahmed',
        mood: 'happy',
        emoji: '😊',
        note: 'Having a wonderful day!',
        date: now,
      ),
      MoodModel(
        id: 'demo2',
        userId: 'user2',
        userName: 'Fatima',
        mood: 'excited',
        emoji: '🤩',
        note: 'Can\'t wait for the weekend!',
        date: now.subtract(Duration(hours: 1)),
      ),
      MoodModel(
        id: 'demo3',
        userId: 'user3',
        userName: 'Omar',
        mood: 'neutral',
        emoji: '😐',
        note: 'Just a regular day',
        date: now.subtract(Duration(hours: 2)),
      ),
    ];
    isLoading.value = false;
  }

  void loadTodaysMoods() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      _loadDemoData();
      return;
    }

    _moodRepository.getTodaysFamilyMoods().listen((moods) {
      todaysMoods.value = moods;
      isLoading.value = false;
    });
  }

  Future<void> addMood(
    String userId,
    String userName,
    String mood,
    String? note,
  ) async {
    if (isDemoMode.value) {
      Get.snackbar('demo_mode'.tr, 'demo_mood_saved'.tr);
      return;
    }

    final emoji = AppConstants.moodEmojis[mood] ?? '😊';
    await _moodRepository.addMood(
      userId: userId,
      userName: userName,
      mood: mood,
      emoji: emoji,
      note: note,
    );
  }
}
