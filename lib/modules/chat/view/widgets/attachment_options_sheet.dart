import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttachmentOptionsSheet extends StatelessWidget {
  final VoidCallback? onImageTap;
  final VoidCallback? onDocumentTap;
  final VoidCallback? onLocationTap;

  const AttachmentOptionsSheet({
    Key? key,
    this.onImageTap,
    this.onDocumentTap,
    this.onLocationTap,
  }) : super(key: key);

  static void show({
    VoidCallback? onImageTap,
    VoidCallback? onDocumentTap,
    VoidCallback? onLocationTap,
  }) {
    final isDark = Get.isDarkMode;

    Get.bottomSheet(
      AttachmentOptionsSheet(
        onImageTap: onImageTap,
        onDocumentTap: onDocumentTap,
        onLocationTap: onLocationTap,
      ),
      isDismissible: true,
      enableDrag: true,
      backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header handle
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[700] : Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Text(
            'Share',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          // Options Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Document
                _AttachmentOption(
                  icon: Icons.description_outlined,
                  label: 'Document',
                  color: Colors.blue,
                  onTap:
                      onDocumentTap ??
                      () {
                        Get.back();
                        Get.snackbar(
                          'Coming Soon',
                          'Document sharing will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      },
                ),

                // Image
                _AttachmentOption(
                  icon: Icons.image_outlined,
                  label: 'Image',
                  color: Colors.purple,
                  onTap:
                      onImageTap ??
                      () {
                        Get.back();
                        Get.snackbar(
                          'Coming Soon',
                          'Image sharing will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      },
                ),

                // Location
                _AttachmentOption(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  color: Colors.green,
                  onTap:
                      onLocationTap ??
                      () {
                        Get.back();
                        Get.snackbar(
                          'Coming Soon',
                          'Location sharing will be available soon',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 2),
                        );
                      },
                ),
              ],
            ),
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachmentOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
