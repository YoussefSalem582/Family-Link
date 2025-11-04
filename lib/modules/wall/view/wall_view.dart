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
        title: Text('Family Wall'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_square),
            onPressed: () => _showCreatePostDialog(context),
            tooltip: 'Create Post',
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
                        'Demo Mode - Showing sample posts',
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
        label: Text('Post'),
      ),
    );
  }

  void _handleLike(bool hasLiked) {
    Get.snackbar(
      'Demo Mode',
      hasLiked ? 'Post unliked' : 'Post liked',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
      backgroundColor: Colors.red.withOpacity(0.1),
    );
  }

  void _handleShare() {
    Get.snackbar(
      'Demo Mode',
      'Share functionality coming soon',
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
            'Demo Mode',
            'Post would be created: "$text"',
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
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Demo Mode',
                'Post would be deleted',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red.withOpacity(0.8),
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
