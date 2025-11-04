import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyPostsWidget extends StatelessWidget {
  final VoidCallback onCreatePost;

  const EmptyPostsWidget({Key? key, required this.onCreatePost})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'wall_no_posts'.tr,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'wall_be_first'.tr,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onCreatePost,
            icon: Icon(Icons.add),
            label: Text('wall_create_post'.tr),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
