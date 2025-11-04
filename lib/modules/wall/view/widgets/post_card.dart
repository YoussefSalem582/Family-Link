import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/avatar_widget.dart';

class PostCard extends StatelessWidget {
  final dynamic post;
  final bool hasLiked;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback? onDelete;

  const PostCard({
    Key? key,
    required this.post,
    required this.hasLiked,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          if (post.text != null && post.text!.isNotEmpty) _buildContent(),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            _buildImagePlaceholder(),
          SizedBox(height: 8),
          _buildLikeCount(),
          Divider(height: 1),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          AvatarWidget(
            name: post.userName,
            photoUrl: post.userPhotoUrl,
            size: 40,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _getTimeAgo(post.createdAt),
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(child: Text('edit'.tr), value: 'edit'),
                PopupMenuItem(child: Text('delete'.tr), value: 'delete'),
              ],
              onSelected: (value) {
                if (value == 'delete' && onDelete != null) {
                  onDelete!();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(post.text!, style: TextStyle(fontSize: 15, height: 1.4)),
    );
  }

  Widget _buildImagePlaceholder() {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image, size: 48, color: Colors.grey[400]),
              SizedBox(height: 8),
              Text(
                'wall_image_preview'.tr,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLikeCount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (post.likeCount > 0) ...[
            Icon(Icons.favorite, size: 16, color: Colors.red),
            SizedBox(width: 4),
            Text(
              '${post.likeCount}',
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: onLike,
              icon: Icon(
                hasLiked ? Icons.favorite : Icons.favorite_border,
                color: hasLiked ? Colors.red : Colors.grey[700],
              ),
              label: Text(
                'wall_like'.tr,
                style: TextStyle(
                  color: hasLiked ? Colors.red : Colors.grey[700],
                ),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onComment,
              icon: Icon(Icons.comment_outlined, color: Colors.grey[700]),
              label: Text(
                'wall_comment'.tr,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: onShare,
              icon: Icon(Icons.share_outlined, color: Colors.grey[700]),
              label: Text(
                'wall_share'.tr,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}${'time_days'.tr} ${'time_ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${'time_hours'.tr} ${'time_ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${'time_minutes'.tr} ${'time_ago'.tr}';
    } else {
      return 'wall_just_now'.tr;
    }
  }
}
