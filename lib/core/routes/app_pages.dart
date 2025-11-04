import 'package:get/get.dart';
import '../../modules/main_container/view/main_container_view.dart';
import '../../modules/main_container/binding/main_container_binding.dart';
import '../../modules/home/view/home_view.dart';
import '../../modules/home/viewmodel/home_viewmodel.dart';
import '../../modules/meals/view/meals_view.dart';
import '../../modules/meals/viewmodel/meals_viewmodel.dart';
import '../../modules/mood/view/mood_view.dart';
import '../../modules/mood/viewmodel/mood_viewmodel.dart';
import '../../modules/map/view/map_view.dart';
import '../../modules/map/viewmodel/map_viewmodel.dart';
import '../../modules/wall/view/wall_view.dart';
import '../../modules/wall/viewmodel/wall_viewmodel.dart';
import '../../modules/profile/view/profile_view.dart';
import '../../modules/profile/viewmodel/profile_viewmodel.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.mainContainer;

  static final routes = [
    GetPage(
      name: AppRoutes.mainContainer,
      page: () => MainContainerView(),
      binding: MainContainerBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => HomeViewModel());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.meals,
      page: () => MealsView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MealsViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.mood,
      page: () => MoodView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MoodViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.map,
      page: () => MapView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => MapViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.wall,
      page: () => WallView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => WallViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => ProfileViewModel());
      }),
      transition: Transition.rightToLeft,
    ),
  ];
}
