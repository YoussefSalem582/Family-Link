import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/theme_service.dart';

class ProfileViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final ThemeService _themeService = Get.find<ThemeService>();
  final _storage = GetStorage();
  late UserRepository _userRepository;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  RxBool isLocationSharingEnabled = true.obs;
  RxBool isLiveLocationEnabled = false.obs;

  // Stats from other modules
  RxInt postsCount = 0.obs;
  RxInt moodsCount = 0.obs;
  RxInt mealsCount = 0.obs;
  RxInt daysActive = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _loadStats();
    _loadLocationSharingState();
  }

  void _loadLocationSharingState() {
    final savedState = _storage.read<bool>('location_sharing_enabled');
    if (savedState != null) {
      isLocationSharingEnabled.value = savedState;
    }

    final savedLiveState = _storage.read<bool>('live_location_enabled');
    if (savedLiveState != null) {
      isLiveLocationEnabled.value = savedLiveState;
    }
  }

  void _loadStats() {
    // Load posts count
    final savedPosts = _storage.read<List>('wall_posts');
    if (savedPosts != null) {
      // Count only posts by current user (demo_user_1)
      postsCount.value = savedPosts
          .where((p) => p['userId'] == 'demo_user_1')
          .length;
    }

    // Load moods count
    final savedMoods = _storage.read<List>('moods_data');
    if (savedMoods != null) {
      // Count only moods by current user
      moodsCount.value = savedMoods
          .where((m) => m['userId'] == 'demo_user_1')
          .length;
    }

    // Load meals count
    final savedMeals = _storage.read<List>('meals_data');
    if (savedMeals != null) {
      // Count only meals by current user
      mealsCount.value = savedMeals
          .where((m) => m['userId'] == 'demo_user_1')
          .length;
    }

    // Calculate days active (unique dates from all activities)
    _calculateDaysActive(savedPosts, savedMoods, savedMeals);

    print(
      '📊 Loaded stats - Posts: ${postsCount.value}, Moods: ${moodsCount.value}, Meals: ${mealsCount.value}, Days: ${daysActive.value}',
    );
  }

  void _calculateDaysActive(List? posts, List? moods, List? meals) {
    Set<String> uniqueDates = {};

    if (posts != null) {
      for (var post in posts) {
        if (post['userId'] == 'demo_user_1' && post['createdAt'] != null) {
          final date = DateTime.parse(post['createdAt']);
          uniqueDates.add('${date.year}-${date.month}-${date.day}');
        }
      }
    }

    if (moods != null) {
      for (var mood in moods) {
        if (mood['userId'] == 'demo_user_1' && mood['date'] != null) {
          final date = DateTime.parse(mood['date']);
          uniqueDates.add('${date.year}-${date.month}-${date.day}');
        }
      }
    }

    if (meals != null) {
      for (var meal in meals) {
        if (meal['userId'] == 'demo_user_1' && meal['date'] != null) {
          final date = DateTime.parse(meal['date']);
          uniqueDates.add('${date.year}-${date.month}-${date.day}');
        }
      }
    }

    daysActive.value = uniqueDates.length;
  }

  void _initializeRepository() {
    try {
      if (!_firebaseService.isInitialized) {
        isDemoMode.value = true;
        _loadDemoData();
        return;
      }
      _userRepository = Get.put(UserRepository());
      loadCurrentUser();
    } catch (e) {
      print('Error initializing profile repository: $e');
      isDemoMode.value = true;
      _loadDemoData();
    }
  }

  void _loadDemoData() {
    currentUser.value = UserModel(
      id: 'demo_user',
      name: 'Demo User',
      email: 'demo@familylink.com',
      location: 'Demo City, Demo Country',
      latitude: 30.0444,
      longitude: 31.2357,
    );
    isLoading.value = false;
  }

  void loadCurrentUser() async {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      _loadDemoData();
      return;
    }

    final userId = _firebaseService.userId;
    if (userId != null) {
      final user = await _userRepository.getUserById(userId);
      currentUser.value = user;
    }
    isLoading.value = false;
  }

  Future<void> refreshProfile() async {
    _loadStats();
    await Future.delayed(Duration(milliseconds: 300));
  }

  Future<void> updateProfile(String name, String location) async {
    if (isDemoMode.value) {
      Get.snackbar('demo_mode'.tr, 'demo_profile_updated'.tr);
      currentUser.value = currentUser.value?.copyWith(
        name: name,
        location: location,
      );
      return;
    }

    if (currentUser.value != null) {
      await _userRepository.updateUser(currentUser.value!.id, {
        'name': name,
        'location': location,
      });
      loadCurrentUser();
    }
  }

  void toggleTheme() {
    _themeService.switchTheme();
  }

  void toggleLocationSharing(bool value) {
    isLocationSharingEnabled.value = value;
    _storage.write('location_sharing_enabled', value);

    // If disabling location sharing, also disable live location
    if (!value) {
      isLiveLocationEnabled.value = false;
      _storage.write('live_location_enabled', false);
    }

    Get.snackbar(
      'Location Sharing',
      value
          ? 'Your location is now visible to family members'
          : 'Your location is now hidden from family members',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: value ? Colors.green : Colors.orange,
      colorText: Colors.white,
      icon: Icon(
        value ? Icons.location_on : Icons.location_off,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void toggleLiveLocation(bool value) {
    // Can only enable live location if location sharing is enabled
    if (value && !isLocationSharingEnabled.value) {
      Get.snackbar(
        'Enable Location Sharing',
        'Please enable location sharing first to use live location',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        icon: Icon(Icons.warning, color: Colors.white),
        margin: EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLiveLocationEnabled.value = value;
    _storage.write('live_location_enabled', value);

    Get.snackbar(
      'Live Location',
      value
          ? '🟢 Broadcasting your real-time location'
          : '🔴 Live location stopped',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
      backgroundColor: value ? Colors.green : Colors.red,
      colorText: Colors.white,
      icon: Icon(
        value ? Icons.navigation : Icons.location_disabled,
        color: Colors.white,
      ),
      margin: EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> signOut() async {
    if (isDemoMode.value) {
      Get.snackbar('demo_mode'.tr, 'demo_signout_unavailable'.tr);
      return;
    }
    await _firebaseService.signOut();
  }
}
