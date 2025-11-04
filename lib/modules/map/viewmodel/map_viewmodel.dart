import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';

class MapViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  late UserRepository _userRepository;

  RxList<UserModel> familyMembers = <UserModel>[].obs;
  RxSet<Marker> markers = <Marker>{}.obs;
  Rx<LatLng> initialPosition = LatLng(30.0444, 31.2357).obs; // Cairo default
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
      loadFamilyLocations();
    } catch (e) {
      print('Error initializing map repository: $e');
      isDemoMode.value = true;
      _loadDemoData();
    }
  }

  void _loadDemoData() {
    // Demo family locations
    familyMembers.value = [
      UserModel(
        id: 'user1',
        name: 'Ahmed',
        email: 'ahmed@example.com',
        location: 'Riyadh, Saudi Arabia',
        latitude: 24.7136,
        longitude: 46.6753,
      ),
      UserModel(
        id: 'user2',
        name: 'Fatima',
        email: 'fatima@example.com',
        location: 'Cairo, Egypt',
        latitude: 30.0444,
        longitude: 31.2357,
      ),
      UserModel(
        id: 'user3',
        name: 'Omar',
        email: 'omar@example.com',
        location: 'Alexandria, Egypt',
        latitude: 31.2001,
        longitude: 29.9187,
      ),
    ];
    _updateMarkers();
  }

  void loadFamilyLocations() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      _loadDemoData();
      return;
    }

    _userRepository.getAllUsers().listen((users) {
      familyMembers.value = users;
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    markers.clear();
    for (var user in familyMembers) {
      if (user.latitude != null && user.longitude != null) {
        markers.add(
          Marker(
            markerId: MarkerId(user.id),
            position: LatLng(user.latitude!, user.longitude!),
            infoWindow: InfoWindow(title: user.name, snippet: user.location),
          ),
        );
      }
    }
  }
}
