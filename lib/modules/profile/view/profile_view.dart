import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../widgets/demo_banner_widget.dart';
import 'widgets/profile_header.dart';
import 'widgets/stat_card.dart';
import 'widgets/family_code_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/about_section.dart';
import 'widgets/edit_profile_dialog.dart';
import 'widgets/about_dialog_widget.dart';

class ProfileView extends GetView<ProfileViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.currentUser.value;
        if (user == null) {
          return Center(child: Text('No user data'));
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'Demo Mode - Showing sample profile'),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Refresh profile data
                  await Future.delayed(Duration(milliseconds: 500));
                  Get.snackbar(
                    'Refreshed',
                    'Profile data refreshed',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                  );
                },
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    // Profile Header
                    ProfileHeader(user: user),
                    SizedBox(height: 24),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.article,
                            value: '12',
                            label: 'Posts',
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.mood,
                            value: '24',
                            label: 'Moods',
                            color: Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            icon: Icons.restaurant,
                            value: '36',
                            label: 'Meals',
                            color: Colors.orange,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            icon: Icons.star,
                            value: '5',
                            label: 'Days Active',
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Family Code Card
                    FamilyCodeCard(),
                    SizedBox(height: 24),

                    // Settings Section
                    SettingsSection(
                      isDarkMode: Get.isDarkMode,
                      onThemeToggle: () => controller.toggleTheme(),
                    ),
                    SizedBox(height: 24),

                    // About Section
                    AboutSection(onAboutTap: () => _showAboutDialog(context)),
                    SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: () {
                        Get.defaultDialog(
                          title: 'Sign Out',
                          middleText: 'Are you sure you want to sign out?',
                          textConfirm: 'Sign Out',
                          textCancel: 'Cancel',
                          confirmTextColor: Colors.white,
                          buttonColor: Colors.red,
                          onConfirm: () {
                            Get.back();
                            controller.signOut();
                          },
                        );
                      },
                      child: Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        currentName: controller.currentUser.value?.name ?? '',
        currentLocation: controller.currentUser.value?.location ?? '',
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AboutDialogWidget());
  }
}
