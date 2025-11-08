import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../viewmodel/chat_list_viewmodel.dart';

class ChatListView extends GetView<ChatListViewModel> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'chats'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.group_add_rounded),
            onPressed: controller.createGroupChat,
            tooltip: 'create_group_chat'.tr,
          ),
        ],
      ),
      body: Obx(() {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        if (controller.chatRooms.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[900] : Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_outline_rounded,
                    size: 80,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'no_chats_yet'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'start_conversation'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshChats,
          color: Theme.of(context).primaryColor,
          backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
          child: ListView.builder(
            itemCount: controller.chatRooms.length,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            itemBuilder: (context, index) {
              final chat = controller.chatRooms[index];
              return Dismissible(
                key: Key(chat.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  controller.deleteChat(chat);
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [Colors.transparent, Colors.red[900]!]
                          : [Colors.transparent, Colors.red[400]!],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: Colors.white, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.openChat(chat),
                    onLongPress: () => controller.togglePinChat(chat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isDark
                                ? Colors.grey[900]!
                                : Colors.grey[200]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar with online indicator
                          Stack(
                            children: [
                              _buildAvatar(chat, context),
                              if (!chat.isGroup && chat.isPinned)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Color(0xFF1E1E1E)
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.push_pin,
                                      size: 12,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          // Chat info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        chat.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: chat.unreadCount > 0
                                              ? FontWeight.w700
                                              : FontWeight.w600,
                                          letterSpacing: 0.2,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (chat.isGroup)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.deepPurple[900]
                                                    ?.withOpacity(0.5)
                                              : Colors.deepPurple[50],
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.people_rounded,
                                              size: 12,
                                              color: isDark
                                                  ? Colors.deepPurple[200]
                                                  : Colors.deepPurple[700],
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  chat.lastMessage,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: chat.unreadCount > 0
                                        ? (isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[700])
                                        : (isDark
                                              ? Colors.grey[600]
                                              : Colors.grey[500]),
                                    fontWeight: chat.unreadCount > 0
                                        ? FontWeight.w500
                                        : FontWeight.normal,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Time and badge
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(chat.lastMessageTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: chat.unreadCount > 0
                                      ? Theme.of(context).primaryColor
                                      : (isDark
                                            ? Colors.grey[600]
                                            : Colors.grey[500]),
                                  fontWeight: chat.unreadCount > 0
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              if (chat.unreadCount > 0) ...[
                                const SizedBox(height: 6),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.8),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(
                                          context,
                                        ).primaryColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    chat.unreadCount > 99
                                        ? '99+'
                                        : '${chat.unreadCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.createNewChat,
        icon: const Icon(Icons.edit_rounded),
        label: Text('new_chat'.tr),
        elevation: 4,
      ),
    );
  }

  Widget _buildAvatar(ChatRoom chat, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (chat.isGroup) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.deepPurple[800]!, Colors.deepPurple[900]!]
                : [Colors.deepPurple[300]!, Colors.deepPurple[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.group_rounded,
          color: isDark ? Colors.deepPurple[100] : Colors.deepPurple[800],
          size: 28,
        ),
      );
    }

    // For individual chats, show user avatar
    if (chat.photoUrl != null && chat.photoUrl!.isNotEmpty) {
      return Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(chat.photoUrl!),
          onBackgroundImageError: (_, __) {},
          child: chat.photoUrl!.isEmpty
              ? Text(
                  chat.name.isNotEmpty ? chat.name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : null,
        ),
      );
    }

    // Fallback to initial letter
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.7),
            Theme.of(context).primaryColor.withOpacity(0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          chat.name.isNotEmpty ? chat.name[0].toUpperCase() : '?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      // Today - show time in 12-hour format with AM/PM
      int hour = time.hour;
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert to 12-hour format
      if (hour == 0) {
        hour = 12; // Midnight
      } else if (hour > 12) {
        hour = hour - 12;
      }

      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } else if (difference.inDays == 1) {
      // Yesterday
      return 'yesterday'.tr;
    } else if (difference.inDays < 7) {
      // This week - show day name
      final days = [
        'monday',
        'tuesday',
        'wednesday',
        'thursday',
        'friday',
        'saturday',
        'sunday',
      ];
      return days[time.weekday - 1].tr;
    } else {
      // Older - show date
      final day = time.day.toString().padLeft(2, '0');
      final month = time.month.toString().padLeft(2, '0');
      return '$day/$month/${time.year}';
    }
  }
}
