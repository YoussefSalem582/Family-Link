import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';

class HomeViewModel extends GetxController {
  late final UserRepository _userRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable list of family members
  RxList<UserModel> familyMembers = <UserModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    loadFamilyMembers();
  }

  void _initializeRepository() {
    try {
      _userRepository = Get.put(UserRepository());
    } catch (e) {
      print('⚠️ Repository initialization failed, using demo mode');
      isDemoMode.value = true;
    }
  }

  // Load all family members
  void loadFamilyMembers() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      // Load demo data
      _loadDemoData();
      return;
    }

    try {
      _userRepository.getAllUsers().listen(
        (users) {
          familyMembers.value = users;
          isLoading.value = false;
        },
        onError: (error) {
          print('Error loading users: $error');
          _loadDemoData();
        },
      );
    } catch (e) {
      print('Error in loadFamilyMembers: $e');
      _loadDemoData();
    }
  }

  // Load demo data for testing without Firebase
  void _loadDemoData() {
    familyMembers.value = [
      UserModel(
        id: '1',
        name: 'Ahmed',
        email: 'ahmed@example.com',
        location: 'Saudi Arabia 🇸🇦',
        status: 'home',
        isHome: true,
        lastSeen: DateTime.now(),
      ),
      UserModel(
        id: '2',
        name: 'Fatima',
        email: 'fatima@example.com',
        location: 'Egypt 🇪🇬',
        status: 'out',
        isHome: false,
        lastSeen: DateTime.now().subtract(Duration(hours: 2)),
      ),
      UserModel(
        id: '3',
        name: 'Omar',
        email: 'omar@example.com',
        location: 'Egypt 🇪🇬',
        status: 'home',
        isHome: true,
        lastSeen: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      UserModel(
        id: '4',
        name: 'Layla',
        email: 'layla@example.com',
        location: 'Egypt 🇪🇬',
        status: 'traveling',
        isHome: false,
        lastSeen: DateTime.now().subtract(Duration(days: 1)),
      ),
    ];
    isLoading.value = false;
    isDemoMode.value = true;
  }

  // Update user status
  Future<void> updateStatus(String userId, String status, bool isHome) async {
    if (isDemoMode.value) {
      print('Demo mode: Cannot update status');
      return;
    }
    try {
      await _userRepository.updateUserStatus(userId, status, isHome);
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  // Count family members at home
  int get membersAtHome => familyMembers.where((user) => user.isHome).length;

  // Count family members out
  int get membersOut => familyMembers.where((user) => !user.isHome).length;
}
