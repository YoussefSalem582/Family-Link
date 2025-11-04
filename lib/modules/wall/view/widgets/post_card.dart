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
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          if (post.text != null && post.text!.isNotEmpty) _buildContent(),
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            _buildImagePlaceholder(),
          SizedBox(height: 12),
          _buildLikeCount(),
          Divider(height: 1, thickness: 1, color: Colors.grey[200]),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.02),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AvatarWidget(
              name: post.userName,
              photoUrl: post.userPhotoUrl,
              size: 48,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                    SizedBox(width: 4),
                    Text(
                      _getTimeAgo(post.createdAt),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (onDelete != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: PopupMenuButton(
                icon: Icon(Icons.more_vert, size: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, size: 18, color: Colors.blue),
                        SizedBox(width: 12),
                        Text('edit'.tr),
                      ],
                    ),
                    value: 'edit',
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 12),
                        Text('delete'.tr, style: TextStyle(color: Colors.red)),
                      ],
                    ),
                    value: 'delete',
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete' && onDelete != null) {
                    onDelete!();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(
        post.text!,
        style: TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.grey[800],
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
      width: double.infinity,
      height: 240,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey[200]!, Colors.grey[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.image_rounded,
                size: 48,
                color: Colors.blue.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'wall_image_preview'.tr,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLikeCount() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (post.likeCount > 0) ...[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite, size: 14, color: Colors.red),
                  SizedBox(width: 4),
                  Text(
                    '${post.likeCount}',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (post.commentCount > 0) ...[
            if (post.likeCount > 0) SizedBox(width: 12),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.comment, size: 14, color: Colors.blue[700]),
                  SizedBox(width: 4),
                  Text(
                    '${post.commentCount}',
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLike,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        hasLiked ? Icons.favorite : Icons.favorite_border,
                        color: hasLiked ? Colors.red : Colors.grey[700],
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'wall_like'.tr,
                        style: TextStyle(
                          color: hasLiked ? Colors.red : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: Colors.grey[200]),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onComment,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.comment_outlined,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'wall_comment'.tr,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: Colors.grey[200]),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onShare,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.share_outlined,
                        color: Colors.grey[700],
                        size: 20,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'wall_share'.tr,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
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
