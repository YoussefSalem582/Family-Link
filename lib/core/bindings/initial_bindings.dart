import 'package:get/get.dart';
import '../theme/theme_service.dart';
import '../services/firebase_service.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/event_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Core Services
    // ThemeService already initialized in main.dart
    if (!Get.isRegistered<ThemeService>()) {
      Get.put(ThemeService(), permanent: true);
    }

    Get.put(StorageService(), permanent: true);

    // Firebase Service (may already be initialized in main)
    if (!Get.isRegistered<FirebaseService>()) {
      Get.put(FirebaseService(), permanent: true);
    }

    // Notification Service (depends on Firebase)
    try {
      Get.put(NotificationService(), permanent: true);
    } catch (e) {
      print('⚠️ Notification service unavailable without Firebase');
    }

    // Event Service
    Get.put(EventService(), permanent: true);
  }
}
