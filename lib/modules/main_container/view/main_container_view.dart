import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_outlined),
              activeIcon: Icon(Icons.restaurant),
              label: 'Meals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood_outlined),
              activeIcon: Icon(Icons.mood),
              label: 'Mood',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              activeIcon: Icon(Icons.forum),
              label: 'Wall',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
