import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/language_controller.dart';
import '../../viewmodel/profile_viewmodel.dart';

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
    final profileController = Get.find<ProfileViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final headerBgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final headerTextColor = isDark ? Colors.grey[300] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: headerBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.settings, size: 16, color: headerTextColor),
              ),
              SizedBox(width: 8),
              Text(
                'profile_settings'.tr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: headerTextColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Language Setting
              Obx(
                () => Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        _showLanguageDialog(context, languageController),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[300]!, Colors.blue[500]!],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'language_select'.tr,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  languageController.currentLanguage == 'en'
                                      ? 'English'
                                      : 'العربية',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.blue[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Divider(height: 1, indent: 68, endIndent: 20),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.dark_mode, color: Colors.purple, size: 24),
                ),
                title: Text(
                  'profile_dark_mode'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (_) => onThemeToggle(),
                  activeColor: Colors.purple,
                ),
              ),
              Divider(height: 1, indent: 68, endIndent: 20),
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.notifications,
                    color: Colors.orange,
                    size: 24,
                  ),
                ),
                title: Text(
                  'profile_notifications'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    Get.snackbar(
                      'settings_notifications_changed'.tr,
                      '${value ? 'profile_enabled'.tr : 'profile_disabled'.tr}',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                      margin: EdgeInsets.all(16),
                      borderRadius: 12,
                      backgroundColor: value ? Colors.green : Colors.orange,
                      colorText: Colors.white,
                      icon: Icon(
                        value ? Icons.check_circle : Icons.info,
                        color: Colors.white,
                      ),
                    );
                  },
                  activeColor: Colors.orange,
                ),
              ),
              Divider(height: 1, indent: 68, endIndent: 20),
              // Location Sharing
              Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: profileController.isLocationSharingEnabled.value
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      profileController.isLocationSharingEnabled.value
                          ? Icons.location_on
                          : Icons.location_off,
                      color: profileController.isLocationSharingEnabled.value
                          ? Colors.green
                          : Colors.grey,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    'profile_location_sharing'.tr,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      profileController.isLocationSharingEnabled.value
                          ? 'Visible to family members'
                          : 'Hidden from family members',
                      style: TextStyle(
                        fontSize: 12,
                        color: profileController.isLocationSharingEnabled.value
                            ? Colors.green[700]
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  trailing: Switch(
                    value: profileController.isLocationSharingEnabled.value,
                    onChanged: (value) {
                      profileController.toggleLocationSharing(value);
                    },
                    activeColor: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    LanguageController controller,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: dialogBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.5 : 0.15),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.language_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'language_select'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Choose your preferred language',
                  style: TextStyle(fontSize: 14, color: subtitleColor),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                // Language Options
                _buildLanguageOption(
                  context,
                  controller,
                  'en',
                  'English',
                  '🇬🇧',
                  Icons.check_circle,
                ),
                SizedBox(height: 12),
                _buildLanguageOption(
                  context,
                  controller,
                  'ar',
                  'العربية',
                  '🇸🇦',
                  Icons.check_circle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    LanguageController controller,
    String langCode,
    String langName,
    String flag,
    IconData icon,
  ) {
    final isSelected = controller.currentLanguage == langCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[50];
    final borderColor = isDark
        ? (isSelected ? Colors.blue : Colors.grey[700]!)
        : (isSelected ? Colors.blue : Colors.grey[200]!);
    final textColor = isSelected
        ? Colors.white
        : (isDark ? Colors.white : Colors.grey[800]!);

    return Container(
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : unselectedBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            controller.changeLanguage(langCode);
            Navigator.pop(context);
            Get.snackbar(
              'language_select'.tr,
              'Language changed to $langName',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.blue,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(16),
              borderRadius: 12,
              icon: Icon(Icons.language, color: Colors.white),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Text(flag, style: TextStyle(fontSize: 32)),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    langName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(icon, color: Colors.white, size: 24)
                else
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
