import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/language_controller.dart';

class SettingsSection extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SettingsSection({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile_settings'.tr,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 12),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Language Setting
              Obx(
                () => ListTile(
                  leading: Icon(Icons.language),
                  title: Text('language_select'.tr),
                  trailing: DropdownButton<String>(
                    value: languageController.currentLanguage,
                    underline: SizedBox(),
                    items: [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'ar', child: Text('العربية')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        languageController.changeLanguage(value);
                      }
                    },
                  ),
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('profile_dark_mode'.tr),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (_) => onThemeToggle(),
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('profile_notifications'.tr),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    Get.snackbar(
                      'settings_notifications_changed'.tr,
                      '${value ? 'profile_enabled'.tr : 'profile_disabled'.tr}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  },
                ),
              ),
              Divider(height: 1),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('profile_location_sharing'.tr),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    Get.snackbar(
                      'settings_location_changed'.tr,
                      '${value ? 'profile_enabled'.tr : 'profile_disabled'.tr}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
