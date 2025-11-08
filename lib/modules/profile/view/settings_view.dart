import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/profile_viewmodel.dart';
import '../../../widgets/demo_banner_widget.dart';
import 'widgets/settings_section.dart';
import 'widgets/about_section.dart';
import 'widgets/about_dialog_widget.dart';

class SettingsView extends GetView<ProfileViewModel> {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        icon: Icons.settings_rounded,
        showBackButton: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              DemoBannerWidget(message: 'demo_profile'.tr),

            // Content
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
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
                              Icon(Icons.logout, color: Colors.white, size: 22),
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
          ],
        );
      }),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => AboutDialogWidget());
  }
}
