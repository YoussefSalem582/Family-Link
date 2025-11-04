import 'package:get/get.dart';
import '../viewmodel/main_container_viewmodel.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../../meals/viewmodel/meals_viewmodel.dart';
import '../../mood/viewmodel/mood_viewmodel.dart';
import '../../map/viewmodel/map_viewmodel.dart';
import '../../wall/viewmodel/wall_viewmodel.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';
import '../../../data/repositories/mood_repository.dart';
import '../../../data/repositories/meal_repository.dart';
import '../../../core/services/firebase_service.dart';

class MainContainerBinding extends Bindings {
  @override
  void dependencies() {
    // Check if Firebase is initialized before registering repositories
    final firebaseService = Get.find<FirebaseService>();

    // Only register repositories if Firebase is initialized
    if (firebaseService.isInitialized) {
      Get.lazyPut(() => MoodRepository(), fenix: true);
      Get.lazyPut(() => MealRepository(), fenix: true);
    }

    // ViewModels
    Get.lazyPut(() => MainContainerViewModel());
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => MealsViewModel());
    Get.lazyPut(() => MoodViewModel());
    Get.lazyPut(() => MapViewModel());
    Get.lazyPut(() => WallViewModel());
    Get.lazyPut(() => ProfileViewModel());
  }
}
