import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/theme/theme_service.dart';

class ProfileViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final ThemeService _themeService = Get.find<ThemeService>();
  late UserRepository _userRepository;

  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;

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

  Future<void> signOut() async {
    if (isDemoMode.value) {
      Get.snackbar('demo_mode'.tr, 'demo_signout_unavailable'.tr);
      return;
    }
    await _firebaseService.signOut();
  }
}
