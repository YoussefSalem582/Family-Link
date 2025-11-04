import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreatePostDialog extends StatelessWidget {
  final Function(String) onPost;

  const CreatePostDialog({Key? key, required this.onPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'wall_create_post'.tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'wall_whats_on_mind'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.edit_note),
              ),
              maxLines: 4,
              maxLength: 500,
            ),
            SizedBox(height: 16),
            // Image picker placeholder
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.image_outlined, color: Colors.grey[600]),
                  SizedBox(width: 12),
                  Text(
                    'wall_add_photo'.tr,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final text = textController.text.trim();
                  if (text.isNotEmpty) {
                    onPost(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('wall_post'.tr, style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
