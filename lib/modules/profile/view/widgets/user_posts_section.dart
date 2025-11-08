import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/post_model.dart';
import '../../../../widgets/section_header.dart';
import '../../../wall/viewmodel/wall_viewmodel.dart';

class UserPostsSection extends StatelessWidget {
  final String? userId;

  const UserPostsSection({Key? key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wallViewModel = Get.find<WallViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      // Get posts by this user
      final userPosts = wallViewModel.posts.where((post) {
        if (userId == null) return true;
        return post.userId == userId;
      }).toList();

      return Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(16),
              child: SectionHeader(
                title: 'Wall Posts',
                icon: Icons.article_rounded,
                iconGradient: LinearGradient(
                  colors: [Colors.blue, Colors.blue.withOpacity(0.7)],
                ),
                actionText: '${userPosts.length}',
                onActionPressed: () {},
              ),
            ),

            // Posts List
            if (userPosts.isEmpty)
              Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No posts yet',
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                itemCount: userPosts.length > 5 ? 5 : userPosts.length,
                separatorBuilder: (context, index) => SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final post = userPosts[index];
                  return _buildPostItem(context, post, isDark);
                },
              ),

            // See all button if more than 5
            if (userPosts.length > 5)
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: TextButton(
                  onPressed: () => Get.toNamed('/wall'),
                  child: Text('View all ${userPosts.length} posts'),
                  style: TextButton.styleFrom(foregroundColor: Colors.blue),
                ),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildPostItem(BuildContext context, PostModel post, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.toNamed('/wall'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[800] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post content
              Text(
                post.text ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),

              // Post meta
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(post.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 16),
                  if (post.imageUrl != null) ...[
                    Icon(
                      Icons.image,
                      size: 14,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Photo',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    SizedBox(width: 16),
                  ],
                  Icon(Icons.favorite, size: 14, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    '${post.likes.length}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.comment, size: 14, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    '${post.commentCount}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
