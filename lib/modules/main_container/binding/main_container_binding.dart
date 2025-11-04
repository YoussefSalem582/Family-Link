import 'package:get/get.dart';
import '../viewmodel/main_container_viewmodel.dart';
import '../../home/viewmodel/home_viewmodel.dart';
import '../../meals/viewmodel/meals_viewmodel.dart';
import '../../mood/viewmodel/mood_viewmodel.dart';
import '../../map/viewmodel/map_viewmodel.dart';
import '../../wall/viewmodel/wall_viewmodel.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';

class MainContainerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainContainerViewModel());
    Get.lazyPut(() => HomeViewModel());
    Get.lazyPut(() => MealsViewModel());
    Get.lazyPut(() => MoodViewModel());
    Get.lazyPut(() => MapViewModel());
    Get.lazyPut(() => WallViewModel());
    Get.lazyPut(() => ProfileViewModel());
  }
}
