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
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'wall_comments'.tr,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final comments = _controller.getComments(widget.post.id);

                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.comment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'wall_no_comments'.tr,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return ListTile(
                      leading: AvatarWidget(
                        name: comment.userName,
                        photoUrl: comment.userPhotoUrl,
                        size: 36,
                      ),
                      title: Text(
                        comment.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.text),
                          SizedBox(height: 4),
                          Text(
                            _getTimeAgo(comment.createdAt),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: 'wall_write_comment'.tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      onSubmitted: (_) => _addComment(),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.send, size: 20),
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
