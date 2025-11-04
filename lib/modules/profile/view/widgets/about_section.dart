import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutSection extends StatelessWidget {
  final VoidCallback onAboutTap;

  const AboutSection({super.key, required this.onAboutTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final headerBgColor = isDark ? Colors.grey[800] : Colors.grey[200];
    final headerTextColor = isDark ? Colors.grey[300] : Colors.grey[700];
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

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
                child: Icon(Icons.info, size: 16, color: headerTextColor),
              ),
              SizedBox(width: 8),
              Text(
                'profile_about'.tr,
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
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple[400]!, Colors.purple[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.help_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  'profile_help_support'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Get.snackbar(
                    'profile_help_support'.tr,
                    'profile_help_coming'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                    margin: EdgeInsets.all(16),
                    borderRadius: 12,
                    backgroundColor: Colors.purple,
                    colorText: Colors.white,
                    icon: Icon(Icons.help, color: Colors.white),
                  );
                },
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
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  'profile_privacy_policy'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: () {
                  Get.snackbar(
                    'profile_privacy_policy'.tr,
                    'profile_privacy_coming'.tr,
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 2),
                    margin: EdgeInsets.all(16),
                    borderRadius: 12,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    icon: Icon(Icons.privacy_tip, color: Colors.white),
                  );
                },
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
                    gradient: LinearGradient(
                      colors: [Colors.orange[400]!, Colors.orange[600]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                title: Text(
                  'profile_about_app'.tr,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'profile_version'.tr,
                    style: TextStyle(fontSize: 12, color: subtitleColor),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
                onTap: onAboutTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
