import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutDialogWidget extends StatelessWidget {
  const AboutDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dialogBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final descBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[50]!;
    final descBorder = isDark ? Colors.grey[700]! : Colors.grey[200]!;
    final featureBg = isDark
        ? Color(0xFF1E1E1E)
        : Colors.blue.withOpacity(0.05);
    final infoColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            // App Icon with gradient background
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.family_restroom, color: Colors.white, size: 48),
            ),
            SizedBox(height: 20),

            // App Name
            Text(
              'app_name'.tr,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: textColor,
              ),
            ),
            SizedBox(height: 8),

            // Version Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.1),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, color: Colors.blue[700], size: 16),
                  SizedBox(width: 6),
                  Text(
                    'profile_version'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Description Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: descBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: descBorder),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'profile_description'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: infoColor,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Features List
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: featureBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildFeatureRow(Icons.location_on, 'Real-time Location'),
                  SizedBox(height: 8),
                  _buildFeatureRow(Icons.restaurant, 'Meal Tracking'),
                  SizedBox(height: 8),
                  _buildFeatureRow(Icons.mood, 'Mood Sharing'),
                  SizedBox(height: 8),
                  _buildFeatureRow(Icons.article, 'Family Wall'),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Built with Flutter
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.flutter_dash, color: Colors.blue[400], size: 18),
                SizedBox(width: 8),
                Text(
                  'profile_built_with'.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Close Button
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Center(
                    child: Text(
                      'close'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Builder(
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final featureIconBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
        final featureTextColor = isDark ? Colors.grey[300] : Colors.grey[700];

        return Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: featureIconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.blue[700], size: 16),
            ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: featureTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}
