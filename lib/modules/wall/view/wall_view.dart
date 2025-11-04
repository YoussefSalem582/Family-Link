import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/wall_viewmodel.dart';
import 'widgets/post_card.dart';
import 'widgets/create_post_dialog.dart';
import 'widgets/comments_sheet.dart';
import 'widgets/empty_posts_widget.dart';

class WallView extends GetView<WallViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('wall_title'.tr),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_square),
            onPressed: () => _showCreatePostDialog(context),
            tooltip: 'wall_create_post'.tr,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Demo Mode Banner
            if (controller.isDemoMode.value)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.orange.shade100,
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange.shade900),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'demo_wall'.tr,
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),

            // Posts List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  controller.loadPosts();
                },
                child: controller.posts.isEmpty
                    ? EmptyPostsWidget(
                        onCreatePost: () => _showCreatePostDialog(context),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: controller.posts.length,
                        itemBuilder: (context, index) {
                          final post = controller.posts[index];
                          final hasLiked = post.likes.contains('current_user');

                          return PostCard(
                            post: post,
                            hasLiked: hasLiked,
                            onLike: () => _handleLike(hasLiked),
                            onComment: () => _showCommentsSheet(context, post),
                            onShare: () => _handleShare(),
                            onDelete: controller.isDemoMode.value
                                ? () => _showDeleteConfirmation(context, post)
                                : null,
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreatePostDialog(context),
        icon: Icon(Icons.edit),
        label: Text('wall_post'.tr),
      ),
    );
  }

  void _handleLike(bool hasLiked) {
    Get.snackbar(
      'demo_mode'.tr,
      hasLiked ? 'wall_unliked'.tr : 'wall_liked'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      backgroundColor: Colors.red.withOpacity(0.1),
    );
  }

  void _handleShare() {
    Get.snackbar(
      'demo_mode'.tr,
      'wall_share_coming_soon'.tr,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CreatePostDialog(
        onPost: (text) {
          Get.back();
          Get.snackbar(
            'demo_mode'.tr,
            'wall_post_created'.tr + ': "$text"',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
            duration: Duration(seconds: 3),
          );
        },
      ),
    );
  }

  void _showCommentsSheet(BuildContext context, dynamic post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CommentsSheet(post: post),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic post) {
    Get.dialog(
      AlertDialog(
        title: Text('wall_delete_post'.tr),
        content: Text('wall_delete_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'demo_mode'.tr,
                'wall_post_deleted'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
