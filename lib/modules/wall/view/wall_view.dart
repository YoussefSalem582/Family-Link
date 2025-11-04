import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../viewmodel/wall_viewmodel.dart';
import 'widgets/post_card.dart';
import 'widgets/create_post_dialog.dart';
import 'widgets/comments_sheet.dart';
import 'widgets/empty_posts_widget.dart';

class WallView extends GetView<WallViewModel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'wall_title',
        icon: Icons.forum_rounded,
        actionIcon: Icons.add_circle_outline,
        actionTooltip: 'wall_create_post',
        onActionPressed: () => _showCreatePostDialog(context),
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
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade50, Colors.orange.shade100],
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.orange.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: Colors.orange.shade900,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'demo_wall'.tr,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _showCreatePostDialog(context),
          icon: Icon(Icons.edit_rounded, size: 22),
          label: Text(
            'wall_post'.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
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
