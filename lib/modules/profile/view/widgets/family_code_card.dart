import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FamilyCodeCard extends StatelessWidget {
  final String familyCode;

  const FamilyCodeCard({super.key, this.familyCode = 'FAM-2024-ABC123'});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.family_restroom, color: Colors.blue),
                SizedBox(width: 12),
                Text(
                  'Family Code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    familyCode,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Get.snackbar(
                        'Copied',
                        'Family code copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Share this code with family members to join',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
