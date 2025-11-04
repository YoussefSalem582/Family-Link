import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/avatar_widget.dart';

class CommentsSheet extends StatelessWidget {
  final dynamic post;

  const CommentsSheet({Key? key, required this.post}) : super(key: key);

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
              child: ListView.builder(
                controller: scrollController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: AvatarWidget(name: 'User ${index + 1}', size: 36),
                    title: Text(
                      'User ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('wall_demo_comment'.tr + ' #${index + 1}'),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
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
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    child: IconButton(
                      icon: Icon(Icons.send, size: 20),
                      onPressed: () {},
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
}
