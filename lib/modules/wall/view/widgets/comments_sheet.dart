import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/avatar_widget.dart';
import '../../viewmodel/wall_viewmodel.dart';

class CommentsSheet extends StatefulWidget {
  final dynamic post;

  const CommentsSheet({Key? key, required this.post}) : super(key: key);

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _commentController = TextEditingController();
  final WallViewModel _controller = Get.find<WallViewModel>();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    _controller.addComment(widget.post.id, 'demo_user_1', 'You', null, text);

    _commentController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final handleColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final dividerColor = isDark ? Colors.grey[800] : Colors.grey[300];
    final emptyBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[100];
    final emptyIcon = isDark ? Colors.grey[600] : Colors.grey[400];
    final emptyText = isDark ? Colors.grey[400] : Colors.grey[700];
    final emptySubtext = isDark ? Colors.grey[600] : Colors.grey[500];
    final commentBubbleBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[100];
    final timeColor = isDark ? Colors.grey[500] : Colors.grey[600];
    final inputBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[100];
    final inputBorder = isDark ? Colors.grey[700] : Colors.grey[300];
    final hintColor = isDark ? Colors.grey[500] : Colors.grey[400];

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: sheetBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.shade300],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.comment_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'wall_comments'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                  Obx(() {
                    final comments = _controller.getComments(widget.post.id);
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${comments.length}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(height: 1, thickness: 1, color: dividerColor),
            Expanded(
              child: Obx(() {
                final comments = _controller.getComments(widget.post.id);

                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: emptyBg,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 64,
                            color: emptyIcon,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'wall_no_comments'.tr,
                          style: TextStyle(
                            color: emptyText,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Be the first to comment!',
                          style: TextStyle(color: emptySubtext, fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: comments.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 16,
                    color: dividerColor,
                  ),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: AvatarWidget(
                              name: comment.userName,
                              photoUrl: comment.userPhotoUrl,
                              size: 40,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: commentBubbleBg,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment.userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        comment.text,
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 6),
                                Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text(
                                    _getTimeAgo(comment.createdAt),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: timeColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Divider(height: 1, thickness: 1, color: dividerColor),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sheetBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: inputBorder!),
                      ),
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: 'wall_write_comment'.tr,
                          hintStyle: TextStyle(color: hintColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _addComment(),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue, Colors.blue.shade400],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send_rounded, size: 20),
                      color: Colors.white,
                      onPressed: _addComment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${'time_ago'.tr}';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${'time_ago'.tr}';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ${'time_ago'.tr}';
    } else {
      return 'wall_just_now'.tr;
    }
  }
}
