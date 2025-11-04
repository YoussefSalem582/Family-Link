import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_bottom_nav.dart';
import '../viewmodel/main_container_viewmodel.dart';
import '../../home/view/home_view.dart';
import '../../meals/view/meals_view.dart';
import '../../mood/view/mood_view.dart';
import '../../map/view/map_view.dart';
import '../../wall/view/wall_view.dart';
import '../../profile/view/profile_view.dart';

class MainContainerView extends GetView<MainContainerViewModel> {
  MainContainerView({Key? key}) : super(key: key);

  final List<Widget> _pages = [
    HomeView(),
    MealsView(),
    MoodView(),
    MapView(),
    WallView(),
    ProfileView(),
  ];

  final List<BottomNavItem> _navItems = const [
    BottomNavItem(icon: Icons.home_rounded, label: 'nav_home'),
    BottomNavItem(icon: Icons.restaurant_menu_rounded, label: 'nav_meals'),
    BottomNavItem(icon: Icons.emoji_emotions_rounded, label: 'nav_mood'),
    BottomNavItem(icon: Icons.map_rounded, label: 'nav_map'),
    BottomNavItem(icon: Icons.forum_rounded, label: 'nav_wall'),
    BottomNavItem(icon: Icons.person_rounded, label: 'nav_profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          items: _navItems,
        ),
      ),
    );
  }
}
