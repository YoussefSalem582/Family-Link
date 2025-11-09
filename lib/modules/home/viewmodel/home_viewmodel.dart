import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';
import '../data/models/user_status_model.dart';
import '../data/models/geofence_model.dart';

class HomeViewModel extends GetxController {
  late final UserRepository _userRepository;
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  // Observable list of family members
  RxList<UserModel> familyMembers = <UserModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;

  // Smart Status Updates
  RxMap<String, UserStatusModel> memberStatuses =
      <String, UserStatusModel>{}.obs;
  RxBool isAutoDetectionEnabled = true.obs;

  // Geofence Locations
  RxList<GeofenceLocation> geofenceLocations = <GeofenceLocation>[].obs;
  RxList<LocationNotification> recentNotifications =
      <LocationNotification>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    loadFamilyMembers();
    _loadDemoStatuses();
    _loadDemoGeofences();
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

  // ==================== SMART STATUS UPDATES ====================

  /// Load demo statuses for all family members
  void _loadDemoStatuses() {
    memberStatuses.value = {
      '1': UserStatusModel(
        userId: '1',
        statusType: StatusType.atHome,
        statusText: 'At Home',
        emoji: '🏠',
        updatedAt: DateTime.now(),
        isAutoDetected: true,
      ),
      '2': UserStatusModel(
        userId: '2',
        statusType: StatusType.shopping,
        statusText: 'Shopping',
        emoji: '🛒',
        updatedAt: DateTime.now().subtract(Duration(minutes: 30)),
        isAutoDetected: false,
      ),
      '3': UserStatusModel(
        userId: '3',
        statusType: StatusType.atSchool,
        statusText: 'At School',
        emoji: '🎓',
        updatedAt: DateTime.now().subtract(Duration(hours: 2)),
        isAutoDetected: true,
      ),
      '4': UserStatusModel(
        userId: '4',
        statusType: StatusType.availableToChat,
        statusText: 'Available to Chat',
        emoji: '🎉',
        updatedAt: DateTime.now().subtract(Duration(minutes: 5)),
        isAutoDetected: false,
      ),
    };
  }

  /// Update user status
  Future<void> updateMemberStatus(
    String userId,
    StatusType statusType, {
    String? customMessage,
  }) async {
    final statusInfo = UserStatusModel.getStatusInfo(statusType);

    final newStatus = UserStatusModel(
      userId: userId,
      statusType: statusType,
      statusText: statusInfo['text'],
      emoji: statusInfo['emoji'],
      updatedAt: DateTime.now(),
      isAutoDetected: false,
      doNotDisturb: statusInfo['dnd'],
      customMessage: customMessage,
    );

    memberStatuses[userId] = newStatus;

    if (!isDemoMode.value) {
      // TODO: Save to Firebase
    }
  }

  /// Toggle auto-detection
  void toggleAutoDetection() {
    isAutoDetectionEnabled.value = !isAutoDetectionEnabled.value;
    if (isAutoDetectionEnabled.value) {
      // TODO: Start location monitoring
    } else {
      // TODO: Stop location monitoring
    }
  }

  /// Get status for a specific member
  UserStatusModel? getStatusForMember(String userId) {
    return memberStatuses[userId];
  }

  // ==================== GEOFENCING & NOTIFICATIONS ====================

  /// Load demo geofence locations
  void _loadDemoGeofences() {
    geofenceLocations.value = [
      GeofenceLocation(
        id: '1',
        name: 'Home',
        emoji: '🏠',
        latitude: 30.0444,
        longitude: 31.2357,
        radiusMeters: 100,
        address: 'Cairo, Egypt',
      ),
      GeofenceLocation(
        id: '2',
        name: 'Work',
        emoji: '💼',
        latitude: 30.0626,
        longitude: 31.2497,
        radiusMeters: 150,
        address: 'Downtown Cairo',
      ),
      GeofenceLocation(
        id: '3',
        name: 'School',
        emoji: '🎓',
        latitude: 30.0131,
        longitude: 31.2089,
        radiusMeters: 200,
        address: 'Maadi, Cairo',
      ),
      GeofenceLocation(
        id: '4',
        name: 'Grandparents',
        emoji: '👴👵',
        latitude: 30.0715,
        longitude: 31.2838,
        radiusMeters: 100,
        address: 'Heliopolis, Cairo',
      ),
    ];

    // Load some recent demo notifications
    recentNotifications.value = [
      LocationNotification(
        userId: '1',
        userName: 'Ahmed',
        location: geofenceLocations[0],
        isArrival: true,
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      LocationNotification(
        userId: '2',
        userName: 'Fatima',
        location: geofenceLocations[1],
        isArrival: false,
        timestamp: DateTime.now().subtract(Duration(minutes: 45)),
        estimatedMinutes: 20,
      ),
    ];
  }

  /// Add a new geofence location
  void addGeofenceLocation(GeofenceLocation location) {
    geofenceLocations.add(location);

    if (!isDemoMode.value) {
      // TODO: Save to Firebase
    }
  }

  /// Remove geofence location
  void removeGeofenceLocation(String locationId) {
    geofenceLocations.removeWhere((loc) => loc.id == locationId);

    if (!isDemoMode.value) {
      // TODO: Remove from Firebase
    }
  }

  /// Toggle location notifications
  void toggleLocationNotifications(
    String locationId,
    bool arrival,
    bool departure,
  ) {
    final index = geofenceLocations.indexWhere((loc) => loc.id == locationId);
    if (index != -1) {
      geofenceLocations[index] = geofenceLocations[index].copyWith(
        notifyOnArrival: arrival,
        notifyOnDeparture: departure,
      );
    }
  }

  /// Simulate receiving a location notification
  void simulateLocationNotification(
    String userId,
    String locationId,
    bool isArrival,
  ) {
    final user = familyMembers.firstWhereOrNull((u) => u.id == userId);
    final location = geofenceLocations.firstWhereOrNull(
      (l) => l.id == locationId,
    );

    if (user != null && location != null) {
      final notification = LocationNotification(
        userId: userId,
        userName: user.name,
        location: location,
        isArrival: isArrival,
        timestamp: DateTime.now(),
        estimatedMinutes: isArrival ? null : 20,
      );

      recentNotifications.insert(0, notification);

      // Show snackbar notification
      Get.snackbar(
        isArrival ? '📍 Arrival' : '🚗 Departure',
        notification.message,
        duration: Duration(seconds: 4),
      );
    }
  }
}
