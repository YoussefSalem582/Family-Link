import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../core/services/firebase_service.dart';

class MapViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final _storage = GetStorage();
  late UserRepository _userRepository;

  RxList<UserModel> familyMembers = <UserModel>[].obs;
  Rx<LatLng> initialPosition = LatLng(30.0444, 31.2357).obs; // Cairo default
  Rx<LatLng>? currentUserLocation;
  RxBool isDemoMode = false.obs;
  RxBool isLoadingLocation = false.obs;
  RxBool isLocationSharingEnabled = true.obs;
  RxBool isLiveLocationEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeRepository();
    _getCurrentLocation();
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

    // Listen for changes
    ever(isLocationSharingEnabled, (_) {
      update();
    });

    ever(isLiveLocationEnabled, (_) {
      update();
    });
  }

  void toggleLiveLocation(bool value) {
    // Can only enable live location if location sharing is enabled
    if (value && !isLocationSharingEnabled.value) {
      Get.snackbar(
        'Enable Location Sharing',
        'Please enable location sharing first',
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
  }

  void loadFamilyLocations() {
    if (isDemoMode.value || !_firebaseService.isInitialized) {
      _loadDemoData();
      return;
    }

    _userRepository.getAllUsers().listen((users) {
      familyMembers.value = users;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        isLoadingLocation.value = false;
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        isLoadingLocation.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentUserLocation = LatLng(position.latitude, position.longitude).obs;
      initialPosition.value = LatLng(position.latitude, position.longitude);

      print('📍 Current location: ${position.latitude}, ${position.longitude}');
      isLoadingLocation.value = false;
    } catch (e) {
      print('Error getting location: $e');
      isLoadingLocation.value = false;
    }
  }

  Future<void> refreshCurrentLocation() async {
    await _getCurrentLocation();
  }
}
