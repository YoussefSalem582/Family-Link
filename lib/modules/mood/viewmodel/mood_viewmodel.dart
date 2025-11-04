import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/mood_model.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../core/utils/constants.dart';
import '../../../core/services/firebase_service.dart';

class MoodViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  late MoodRepository _moodRepository;
  final _storage = GetStorage();

  RxList<MoodModel> todaysMoods = <MoodModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  Rx<String> selectedMood = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedMoods();
    _initializeRepository();
  }

  void _loadSavedMoods() {
    final savedMoods = _storage.read<List>('moods_data');
    if (savedMoods != null) {
      todaysMoods.value = savedMoods
          .map((m) => _moodFromStorage(Map<String, dynamic>.from(m)))
          .toList();
      print('✅ Loaded ${todaysMoods.length} saved moods from storage');
    } else {
      print('ℹ️ No saved moods found in storage');
    }
  }

  void _saveMoods() {
    _storage.write(
      'moods_data',
      todaysMoods.map((m) => _moodToStorage(m)).toList(),
    );
    print('💾 Saved ${todaysMoods.length} moods to storage');
  }

  // Storage serialization helpers
  Map<String, dynamic> _moodToStorage(MoodModel mood) {
    return {
      'id': mood.id,
      'userId': mood.userId,
      'userName': mood.userName,
      'mood': mood.mood,
      'emoji': mood.emoji,
      'note': mood.note,
      'date': mood.date.toIso8601String(),
    };
  }

  MoodModel _moodFromStorage(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      mood: json['mood'] ?? '',
      emoji: json['emoji'] ?? '😊',
      note: json['note'],
      date: DateTime.parse(json['date']),
    );
  }

  void _initializeRepository() {
    try {
      if (!_firebaseService.isInitialized) {
        isDemoMode.value = true;
        // Only load demo data if no saved moods exist
        if (todaysMoods.isEmpty) {
          _loadDemoData();
        } else {
          isLoading.value = false;
        }
        return;
      }
      // Use Get.find since repository is registered in MainContainerBinding
      if (Get.isRegistered<MoodRepository>()) {
        _moodRepository = Get.find<MoodRepository>();
      } else {
        _moodRepository = Get.put(MoodRepository());
      }
      loadTodaysMoods();
    } catch (e) {
      print('Error initializing mood repository: $e');
      isDemoMode.value = true;
      // Only load demo data if no saved moods exist
      if (todaysMoods.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
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
    print('ℹ️ Loaded initial demo moods (first time only)');
  }

  void loadTodaysMoods() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      // In demo mode, don't reload demo data if we already have moods
      if (todaysMoods.isEmpty) {
        _loadDemoData();
      } else {
        isLoading.value = false;
      }
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
      // In demo mode, add mood locally
      final emoji = AppConstants.moodEmojis[mood] ?? '😊';
      final newMood = MoodModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        userName: userName,
        mood: mood,
        emoji: emoji,
        note: note,
        date: DateTime.now(),
      );

      todaysMoods.insert(0, newMood);
      todaysMoods.refresh();
      _saveMoods(); // Save to storage

      Get.snackbar(
        'success'.tr,
        'mood_shared'.tr,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    try {
      final emoji = AppConstants.moodEmojis[mood] ?? '😊';
      final success = await _moodRepository.addMood(
        userId: userId,
        userName: userName,
        mood: mood,
        emoji: emoji,
        note: note,
      );

      if (success) {
        Get.snackbar(
          'success'.tr,
          'mood_shared'.tr,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to share mood',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }
}
