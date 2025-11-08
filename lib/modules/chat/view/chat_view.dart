import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/demo_banner_widget.dart';
import '../viewmodel/chat_viewmodel.dart';
import 'widgets/message_bubble.dart';
import 'widgets/date_separator.dart';
import 'widgets/message_input.dart';
import 'widgets/chat_empty_state.dart';
import 'widgets/chat_search_bar.dart';

class ChatView extends StatefulWidget {
  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  bool _shouldShowDate(List messages, int index) {
    if (index == 0) return true;

    final current = messages[index].createdAt;
    final previous = messages[index - 1].createdAt;

    return current.year != previous.year ||
        current.month != previous.month ||
        current.day != previous.day;
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatViewModel());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Color(0xFF121212) : Colors.white,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        titleSpacing: 0,
        title: GestureDetector(
          onTap: controller.isGroup
              ? () => controller.showGroupMembers()
              : () {
                  Get.toNamed(
                    '/profile',
                    arguments: {
                      'userId': controller.receiverId,
                      'userName': controller.receiverName,
                    },
                  );
                },
          child: Row(
            children: [
              // Show group icon or avatar
              if (controller.isGroup)
                CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Icon(Icons.group, color: Colors.deepPurple[700]),
                )
              else
                CircleAvatar(
                  backgroundImage: controller.receiverPhotoUrl != null
                      ? NetworkImage(controller.receiverPhotoUrl!)
                      : null,
                  child: controller.receiverPhotoUrl == null
                      ? Text(
                          controller.receiverName[0].toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.receiverName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.3,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (controller.isGroup)
                      Text(
                        'Tap to view ${controller.groupMembers.length} members',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      )
                    else
                      Text(
                        'Tap to view profile',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Group info button (only for groups)
          if (controller.isGroup)
            IconButton(
              icon: Icon(Icons.info_outline),
              tooltip: 'Group Info',
              onPressed: () => controller.showGroupMembers(),
            ),
          // Search button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => controller.toggleSearch(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Demo Mode Banner
          Obx(() {
            if (controller.isDemoMode.value) {
              return DemoBannerWidget(
                message: 'Demo Mode - Messages are stored locally',
              );
            }
            return SizedBox.shrink();
          }),

          // Search Bar
          ChatSearchBar(controller: controller),

          // Messages List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              // Use filtered messages if searching, otherwise use all messages
              final displayMessages = controller.isSearching.value
                  ? controller.filteredMessages
                  : controller.messages;

              if (displayMessages.isEmpty) {
                return ChatEmptyState(isDark: isDark);
              }

              // Scroll to bottom when messages change
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollToBottom();
              });

              return ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16),
                itemCount: displayMessages.length,
                itemBuilder: (context, index) {
                  final message = displayMessages[index];
                  final isMe = message.senderId == controller.currentUserId;
                  final showDate = _shouldShowDate(displayMessages, index);

                  return Column(
                    children: [
                      if (showDate)
                        DateSeparator(date: message.createdAt, isDark: isDark),
                      MessageBubble(
                        message: message,
                        isMe: isMe,
                        controller: controller,
                      ),
                    ],
                  );
                },
              );
            }),
          ),

          // Message Input
          MessageInput(controller: controller),
        ],
      ),
    );
  }
}
