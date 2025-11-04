import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/routes/app_routes.dart';

class OnboardingViewModel extends GetxController {
  final PageController pageController = PageController();
  final _storage = GetStorage();

  final currentPage = 0.obs;

  final List<Map<String, dynamic>> onboardingPages = [
    {
      'title': 'Stay Connected',
      'description':
          'Keep in touch with your family members in real-time. Share your location, updates, and moments together.',
      'icon': Icons.people_rounded,
      'color': Colors.blue,
    },
    {
      'title': 'Share Meals Together',
      'description':
          'Plan and track family meals. Know who\'s eating what and when, making family time easier to coordinate.',
      'icon': Icons.restaurant_rounded,
      'color': Colors.orange,
    },
    {
      'title': 'Track Family Moods',
      'description':
          'Share how you\'re feeling with your family. Stay emotionally connected and support each other better.',
      'icon': Icons.mood_rounded,
      'color': Colors.purple,
    },
    {
      'title': 'Real-time Location',
      'description':
          'See where your family members are on the map. Feel secure knowing everyone is safe and sound.',
      'icon': Icons.map_rounded,
      'color': Colors.green,
    },
    {
      'title': 'Family Wall',
      'description':
          'Share photos, updates, and memories on your private family wall. Create lasting memories together.',
      'icon': Icons.photo_library_rounded,
      'color': Colors.pink,
    },
  ];

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < onboardingPages.length - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Mark onboarding as complete and navigate to main app
      completeOnboarding();
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  void completeOnboarding() {
    _storage.write('hasSeenOnboarding', true);
    Get.offAllNamed(AppRoutes.mainContainer);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
