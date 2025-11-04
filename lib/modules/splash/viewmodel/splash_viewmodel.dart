import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';

class SplashViewModel extends GetxController {
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate app initialization (check auth, load data, etc.)
    await Future.delayed(Duration(seconds: 2));

    // Check if user has seen onboarding
    final hasSeenOnboarding = _storage.read('hasSeenOnboarding') ?? false;

    if (!hasSeenOnboarding) {
      // First time user - show onboarding
      Get.offAllNamed(AppRoutes.onboarding);
    } else {
      // Check if user is logged in
      final isLoggedIn = _storage.read('isLoggedIn') ?? false;

      if (isLoggedIn) {
        // User is logged in - go to main app
        Get.offAllNamed(AppRoutes.mainContainer);
      } else {
        // User not logged in - go to login (for now, go to main)
        // TODO: Implement proper auth flow
        Get.offAllNamed(AppRoutes.mainContainer);
      }
    }
  }
}
