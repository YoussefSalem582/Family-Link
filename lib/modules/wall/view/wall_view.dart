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
                          final hasLiked = post.likes.contains('demo_user_1');

                          return PostCard(
                            post: post,
                            hasLiked: hasLiked,
                            onLike: () => _handleLike(post.id, hasLiked),
                            onComment: () => _showCommentsSheet(context, post),
                            onShare: () => _handleShare(),
                            onDelete:
                                controller.isDemoMode.value ||
                                    post.userId == 'demo_user_1'
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

  void _handleLike(String postId, bool hasLiked) {
    controller.toggleLike(postId, 'demo_user_1');
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
          controller.createPost('demo_user_1', 'You', null, text);
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
              controller.deletePost(post.id, 'demo_user_1');
            },
            child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
