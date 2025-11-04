import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
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
      appBar: CustomAppBar(
        title: 'profile_title',
        icon: Icons.person_rounded,
        actionIcon: Icons.edit_outlined,
        actionTooltip: 'profile_edit',
        onActionPressed: () => _showEditDialog(context),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = controller.currentUser.value;
        if (user == null) {
          return Center(child: Text('profile_no_data'.tr));
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'demo_profile'.tr),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.refreshProfile(),
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
                          child: Obx(
                            () => StatCard(
                              icon: Icons.article,
                              value: '${controller.postsCount.value}',
                              label: 'profile_posts'.tr,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => StatCard(
                              icon: Icons.mood,
                              value: '${controller.moodsCount.value}',
                              label: 'profile_moods'.tr,
                              color: Colors.purple,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => StatCard(
                              icon: Icons.restaurant,
                              value: '${controller.mealsCount.value}',
                              label: 'profile_meals'.tr,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => StatCard(
                              icon: Icons.star,
                              value: '${controller.daysActive.value}',
                              label: 'profile_days_active'.tr,
                              color: Colors.green,
                            ),
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
                    SizedBox(height: 32),

                    // Sign Out Button
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red[400]!, Colors.red[600]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Get.defaultDialog(
                              title: 'profile_sign_out'.tr,
                              middleText: 'profile_sign_out_confirm'.tr,
                              textConfirm: 'profile_sign_out'.tr,
                              textCancel: 'cancel'.tr,
                              confirmTextColor: Colors.white,
                              buttonColor: Colors.red[700],
                              cancelTextColor: Colors.grey[700],
                              radius: 16,
                              onConfirm: () {
                                Get.back();
                                controller.signOut();
                              },
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'profile_sign_out'.tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
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
