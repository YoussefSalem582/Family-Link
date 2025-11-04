import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxBool isLocationEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLocationEnabled.value = false;
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLocationEnabled.value = false;
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLocationEnabled.value = false;
      return;
    }

    isLocationEnabled.value = true;
    await getCurrentLocation();
  }

  Future<Position?> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      currentPosition.value = position;
      return position;
    } catch (e) {
      print('Error getting location: $e');
      return null;
    }
  }

  Future<double> getDistanceBetween(
    double startLat,
    double startLng,
    double endLat,
    double endLng,
  ) async {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }

  // Check if user is at home (within 100m of home location)
  Future<bool> isAtHome(double homeLat, double homeLng) async {
    Position? position = await getCurrentLocation();
    if (position == null) return false;

    double distance = await getDistanceBetween(
      position.latitude,
      position.longitude,
      homeLat,
      homeLng,
    );

    return distance <= 100; // Within 100 meters
  }
}
