import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/viewmodel/home_viewmodel.dart';

class ChatListViewModel extends GetxController {
  // Get HomeViewModel to access family members
  final HomeViewModel _homeViewModel = Get.find<HomeViewModel>();

  // Current user
  final currentUserId = 'demo_user_1';
  final currentUserName = 'You';

  // State
  RxList<ChatRoom> chatRooms = <ChatRoom>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeChats();
  }

  // Public method for pull-to-refresh
  Future<void> refreshChats() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    _initializeChats();
  }

  void _initializeChats() {
    isLoading.value = true;

    // For now, always use demo mode
    isDemoMode.value = true;

    if (isDemoMode.value) {
      _loadDemoChats();
    } else {
      _loadFirebaseChats();
    }

    isLoading.value = false;
  }

  void _loadDemoChats() {
    // Get real family members from HomeViewModel
    final familyMembers = _homeViewModel.familyMembers;

    // Filter out current user
    final otherMembers = familyMembers
        .where((m) => m.id != currentUserId)
        .toList();

    // Create individual chats with some members
    final individualChats = <ChatRoom>[];

    if (otherMembers.length > 0) {
      // Chat with first member (Fatima)
      individualChats.add(
        ChatRoom(
          id: 'chat_${otherMembers[0].id}',
          name: otherMembers[0].name,
          photoUrl: otherMembers[0].photoUrl,
          isGroup: false,
          lastMessage: 'Thanks for the update!',
          lastMessageTime: DateTime.now().subtract(Duration(minutes: 5)),
          unreadCount: 2,
          members: [currentUserId, otherMembers[0].id],
          memberNames: {
            currentUserId: 'Ahmed',
            otherMembers[0].id: otherMembers[0].name,
          },
        ),
      );
    }

    if (otherMembers.length > 1) {
      // Chat with second member (Omar)
      individualChats.add(
        ChatRoom(
          id: 'chat_${otherMembers[1].id}',
          name: otherMembers[1].name,
          photoUrl: otherMembers[1].photoUrl,
          isGroup: false,
          lastMessage: 'See you at dinner',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
          unreadCount: 0,
          members: [currentUserId, otherMembers[1].id],
          memberNames: {
            currentUserId: 'Ahmed',
            otherMembers[1].id: otherMembers[1].name,
          },
        ),
      );
    }

    if (otherMembers.length > 2) {
      // Chat with third member (Layla)
      individualChats.add(
        ChatRoom(
          id: 'chat_${otherMembers[2].id}',
          name: otherMembers[2].name,
          photoUrl: otherMembers[2].photoUrl,
          isGroup: false,
          lastMessage: 'Great idea! 👍',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
          unreadCount: 0,
          members: [currentUserId, otherMembers[2].id],
          memberNames: {
            currentUserId: 'Ahmed',
            otherMembers[2].id: otherMembers[2].name,
          },
        ),
      );
    }

    // Create group chats with all family members
    final groupChats = <ChatRoom>[
      ChatRoom(
        id: 'group_family',
        name: 'Family Group',
        photoUrl: null,
        isGroup: true,
        lastMessage: 'Don\'t forget the grocery shopping',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 15)),
        unreadCount: 5,
        members: familyMembers.map((m) => m.id).toList(),
        memberCount: familyMembers.length,
        memberNames: Map.fromEntries(
          familyMembers.map((m) => MapEntry(m.id, m.name)),
        ),
      ),
    ];

    // Add Weekend Plans group if there are enough members
    if (otherMembers.length >= 2) {
      final weekendMembers = [
        currentUserId,
        otherMembers[0].id,
        if (otherMembers.length > 1) otherMembers[1].id,
      ];

      groupChats.add(
        ChatRoom(
          id: 'group_weekend',
          name: 'Weekend Plans',
          photoUrl: null,
          isGroup: true,
          lastMessage: 'Let\'s go to the beach!',
          lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
          unreadCount: 0,
          members: weekendMembers,
          memberCount: weekendMembers.length,
          memberNames: {
            currentUserId: 'Ahmed',
            otherMembers[0].id: otherMembers[0].name,
            if (otherMembers.length > 1)
              otherMembers[1].id: otherMembers[1].name,
          },
        ),
      );
    }

    chatRooms.value = [...individualChats, ...groupChats];

    // Sort chats: pinned first, then by most recent message
    _sortChatRooms();
  }

  void _sortChatRooms() {
    chatRooms.sort((a, b) {
      // Pinned chats first
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      // Then by most recent message (newest first)
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
  }

  void _loadFirebaseChats() {
    // TODO: Load chats from Firebase
    // Listen to user's chat rooms and update UI
    chatRooms.value = [];
  }

  void openChat(ChatRoom chatRoom) {
    // Clear unread count when opening chat
    final index = chatRooms.indexWhere((chat) => chat.id == chatRoom.id);
    if (index != -1 && chatRoom.unreadCount > 0) {
      chatRooms[index] = chatRoom.copyWith(unreadCount: 0);
    }

    if (chatRoom.isGroup) {
      // Navigate to group chat
      Get.toNamed(
        '/chat',
        arguments: {
          'receiverId': chatRoom.id,
          'receiverName': chatRoom.name,
          'receiverPhotoUrl': chatRoom.photoUrl,
          'isGroup': true,
          'members': chatRoom.members,
          'memberNames': chatRoom.memberNames,
        },
      );
    } else {
      // Navigate to individual chat
      final otherUserId = chatRoom.members.firstWhere(
        (id) => id != currentUserId,
      );
      Get.toNamed(
        '/chat',
        arguments: {
          'receiverId': otherUserId,
          'receiverName': chatRoom.name,
          'receiverPhotoUrl': chatRoom.photoUrl,
          'isGroup': false,
        },
      );
    }
  }

  void createNewChat() {
    // Show dialog to select family member
    _showSelectMemberDialog();
  }

  void createGroupChat() {
    // Show dialog to select multiple members and create group
    _showCreateGroupDialog();
  }

  void togglePinChat(ChatRoom chatRoom) {
    final index = chatRooms.indexWhere((chat) => chat.id == chatRoom.id);
    if (index != -1) {
      final updatedChat = chatRoom.copyWith(isPinned: !chatRoom.isPinned);
      chatRooms[index] = updatedChat;

      // Sort chats: pinned first, then by most recent message
      _sortChatRooms();

      Get.snackbar(
        chatRoom.isPinned ? 'Unpinned' : 'Pinned',
        '${chatRoom.name} ${chatRoom.isPinned ? 'unpinned' : 'pinned'} successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    }
  }

  void deleteChat(ChatRoom chatRoom) {
    Get.defaultDialog(
      title: 'Delete Chat',
      middleText:
          'Are you sure you want to delete this chat with ${chatRoom.name}?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        chatRooms.removeWhere((chat) => chat.id == chatRoom.id);
        Get.back();
        Get.snackbar(
          'Deleted',
          'Chat with ${chatRoom.name} has been deleted',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      },
    );
  }

  void showGroupMembers(ChatRoom chatRoom) {
    if (!chatRoom.isGroup) return;

    final memberNames = chatRoom.memberNames ?? {};
    final memberList = chatRoom.members
        .map((memberId) => memberNames[memberId] ?? 'Unknown')
        .toList();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[100],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.group,
                      color: Colors.deepPurple[700],
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatRoom.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${memberList.length} members',
                          style: TextStyle(
                            fontSize: 12,
                            color: Get.theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 8),
              Text(
                'Group Members',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Get.theme.hintColor,
                ),
              ),
              SizedBox(height: 12),
              ...memberList.asMap().entries.map((entry) {
                final index = entry.key;
                final memberName = entry.value;
                final memberId = chatRoom.members[index];
                final isCurrentUser = memberId == currentUserId;

                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  leading: CircleAvatar(
                    backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
                    child: Text(
                      memberName[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Get.theme.primaryColor,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Text(memberName),
                      if (isCurrentUser) ...[
                        SizedBox(width: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              fontSize: 11,
                              color: Get.theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectMemberDialog() async {
    // Get real family members (excluding current user)
    final familyMembers = _homeViewModel.familyMembers;
    final availableMembers = familyMembers
        .where((m) => m.id != currentUserId)
        .map((m) => {'id': m.id, 'name': m.name, 'photoUrl': m.photoUrl})
        .toList();

    if (availableMembers.isEmpty) {
      Get.snackbar(
        'No Members',
        'No family members available to chat with',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.person_add, color: Get.theme.primaryColor),
                  SizedBox(width: 12),
                  Text(
                    'New Chat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Select a family member to start chatting',
                style: TextStyle(fontSize: 12, color: Get.theme.hintColor),
              ),
              SizedBox(height: 16),
              ...availableMembers.map((member) {
                // Check if chat already exists
                final existingChat = chatRooms.firstWhereOrNull(
                  (chat) =>
                      !chat.isGroup && chat.members.contains(member['id']),
                );

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      (member['name'] as String)[0].toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(member['name'] as String),
                  subtitle: existingChat != null
                      ? Text('Chat exists', style: TextStyle(fontSize: 12))
                      : null,
                  onTap: () {
                    Get.back();
                    if (existingChat != null) {
                      openChat(existingChat);
                    } else {
                      _createNewIndividualChat(
                        member['id'] as String,
                        member['name'] as String,
                        member['photoUrl'],
                      );
                    }
                  },
                );
              }).toList(),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createNewIndividualChat(
    String memberId,
    String memberName,
    String? photoUrl,
  ) {
    // Create new chat room
    final newChat = ChatRoom(
      id: 'chat_${memberId}_${DateTime.now().millisecondsSinceEpoch}',
      name: memberName,
      photoUrl: photoUrl,
      isGroup: false,
      lastMessage: 'No messages yet',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      members: [currentUserId, memberId],
    );

    chatRooms.insert(0, newChat);
    _sortChatRooms(); // Ensure proper sort order
    openChat(newChat);
  }

  Future<void> _showCreateGroupDialog() async {
    // Get real family members (excluding current user)
    final familyMembers = _homeViewModel.familyMembers;
    final availableMembers = familyMembers
        .where((m) => m.id != currentUserId)
        .map((m) => {'id': m.id, 'name': m.name, 'photoUrl': m.photoUrl})
        .toList();

    if (availableMembers.isEmpty) {
      Get.snackbar(
        'No Members',
        'Need at least 2 family members to create a group',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
      return;
    }

    final selectedMembers = <String>[].obs;
    final groupNameController = Get.put(
      TextEditingController(),
      tag: 'groupName',
    );

    await Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.group_add, color: Get.theme.primaryColor),
                  SizedBox(width: 12),
                  Text(
                    'Create Group',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                controller: groupNameController,
                decoration: InputDecoration(
                  labelText: 'Group Name',
                  hintText: 'Enter group name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: Icon(Icons.edit),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Select Members (minimum 2)',
                style: TextStyle(
                  fontSize: 12,
                  color: Get.theme.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              ...availableMembers.map((member) {
                return Obx(() {
                  final isSelected = selectedMembers.contains(member['id']);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (value) {
                      if (value == true) {
                        selectedMembers.add(member['id'] as String);
                      } else {
                        selectedMembers.remove(member['id']);
                      }
                    },
                    title: Text(member['name'] as String),
                    secondary: CircleAvatar(
                      child: Text(
                        (member['name'] as String)[0].toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                });
              }).toList(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.delete<TextEditingController>(tag: 'groupName');
                      Get.back();
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  Obx(() {
                    final canCreate =
                        selectedMembers.length >= 2 &&
                        groupNameController.text.isNotEmpty;
                    return ElevatedButton(
                      onPressed: canCreate
                          ? () {
                              _createNewGroupChat(
                                groupNameController.text,
                                selectedMembers.toList(),
                              );
                              Get.delete<TextEditingController>(
                                tag: 'groupName',
                              );
                              Get.back();
                            }
                          : null,
                      child: Text('Create'),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createNewGroupChat(String groupName, List<String> memberIds) {
    final newGroup = ChatRoom(
      id: 'group_${DateTime.now().millisecondsSinceEpoch}',
      name: groupName,
      photoUrl: null,
      isGroup: true,
      lastMessage: 'Group created',
      lastMessageTime: DateTime.now(),
      unreadCount: 0,
      members: [currentUserId, ...memberIds],
      memberCount: memberIds.length + 1,
    );

    chatRooms.insert(0, newGroup);
    _sortChatRooms(); // Ensure proper sort order

    Get.snackbar(
      'Success',
      'Group "$groupName" created successfully',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 2),
    );

    openChat(newGroup);
  }
}

// Chat Room Model
class ChatRoom {
  final String id;
  final String name;
  final String? photoUrl;
  final bool isGroup;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final List<String> members;
  final int? memberCount;
  final bool isPinned;
  final Map<String, String>? memberNames; // Map of member ID to name

  ChatRoom({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.isGroup,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    required this.members,
    this.memberCount,
    this.isPinned = false,
    this.memberNames,
  });

  ChatRoom copyWith({
    String? id,
    String? name,
    String? photoUrl,
    bool? isGroup,
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
    List<String>? members,
    int? memberCount,
    bool? isPinned,
    Map<String, String>? memberNames,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      isGroup: isGroup ?? this.isGroup,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      members: members ?? this.members,
      memberCount: memberCount ?? this.memberCount,
      isPinned: isPinned ?? this.isPinned,
      memberNames: memberNames ?? this.memberNames,
    );
  }
}
