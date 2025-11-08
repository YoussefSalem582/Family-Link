import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/models/message_model.dart';
import '../../../core/services/firebase_service.dart';

class ChatViewModel extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final _storage = GetStorage();

  // Receiver info (passed from arguments)
  late String receiverId;
  late String receiverName;
  String? receiverPhotoUrl;
  late bool isGroup;
  List<String> groupMembers = [];
  Map<String, String> memberNames = {};

  // Current user
  final currentUserId = 'demo_user_1';
  final currentUserName = 'You';

  // Messages
  RxList<MessageModel> messages = <MessageModel>[].obs;
  RxList<MessageModel> filteredMessages = <MessageModel>[].obs;
  RxBool isLoading = true.obs;
  RxBool isDemoMode = false.obs;
  RxBool isSending = false.obs;

  // Search
  RxBool isSearching = false.obs;
  RxString searchQuery = ''.obs;

  // Typing indicator
  RxBool isTyping = false.obs;
  RxBool isReceiverTyping = false.obs;

  // Reactions - Map of messageId to Map of emoji to count
  RxMap<String, Map<String, int>> messageReactions =
      <String, Map<String, int>>{}.obs;

  // Chat ID (combination of two user IDs)
  late String chatId;

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  void _initializeChat() {
    // Get receiver info from arguments
    final args = Get.arguments as Map<String, dynamic>?;
    receiverId = args?['receiverId'] ?? '';
    receiverName = args?['receiverName'] ?? 'User';
    receiverPhotoUrl = args?['receiverPhotoUrl'];
    isGroup = args?['isGroup'] ?? false;

    if (isGroup) {
      groupMembers = List<String>.from(args?['members'] ?? []);
      memberNames = Map<String, String>.from(args?['memberNames'] ?? {});
    }

    // Generate chat ID (sorted user IDs for consistency)
    chatId = _generateChatId(currentUserId, receiverId);

    // Initialize
    if (!_firebaseService.isInitialized) {
      isDemoMode.value = true;
      _loadDemoData();
    } else {
      loadMessages();
    }
  }

  String _generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  void _loadDemoData() {
    final savedMessages = _storage.read<List>('chat_$chatId');
    if (savedMessages != null) {
      messages.value = savedMessages
          .map((m) => MessageModel.fromMap(Map<String, dynamic>.from(m)))
          .toList();
    } else {
      // Initial demo messages
      messages.value = [
        MessageModel(
          id: '1',
          chatId: chatId,
          senderId: receiverId,
          senderName: receiverName,
          senderPhotoUrl: receiverPhotoUrl,
          receiverId: currentUserId,
          text: 'Hi! How are you doing?',
          createdAt: DateTime.now().subtract(Duration(hours: 2)),
          isRead: true,
        ),
        MessageModel(
          id: '2',
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          receiverId: receiverId,
          text: 'I\'m doing great, thanks! How about you?',
          createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 55)),
          isRead: true,
        ),
        MessageModel(
          id: '3',
          chatId: chatId,
          senderId: receiverId,
          senderName: receiverName,
          senderPhotoUrl: receiverPhotoUrl,
          receiverId: currentUserId,
          text: 'Pretty good! Just wanted to check in.',
          createdAt: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
          isRead: true,
        ),
      ];
      _saveMessages();
    }

    // Load reactions
    _loadReactions();

    // Initialize filtered messages
    filteredMessages.value = messages;

    isLoading.value = false;
  }

  void loadMessages() {
    // TODO: Load from Firestore in Phase 2
    _loadDemoData();
  }

  void _saveMessages() {
    _storage.write('chat_$chatId', messages.map((m) => m.toMap()).toList());
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    isSending.value = true;

    try {
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: currentUserId,
        senderName: currentUserName,
        receiverId: receiverId,
        text: text.trim(),
        createdAt: DateTime.now(),
        isRead: false,
      );

      if (isDemoMode.value) {
        // Add message locally
        messages.add(message);
        messages.refresh();

        // Update filtered messages if searching
        if (searchQuery.value.isNotEmpty) {
          if (message.text.toLowerCase().contains(
            searchQuery.value.toLowerCase(),
          )) {
            filteredMessages.add(message);
            filteredMessages.refresh();
          }
        } else {
          filteredMessages.value = messages;
        }

        _saveMessages();

        Get.snackbar(
          'success'.tr,
          'Message sent',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );

        // Simulate receiver typing after a delay
        Future.delayed(Duration(seconds: 3), () {
          simulateReceiverTyping();
        });
      } else {
        // TODO: Send to Firestore in Phase 2
        // _showMessageNotification would be called here for received messages
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to send message',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isSending.value = false;
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      if (isDemoMode.value) {
        messages.removeWhere((m) => m.id == messageId);
        messages.refresh();
        filteredMessages.removeWhere((m) => m.id == messageId);
        filteredMessages.refresh();
        _saveMessages();

        // Also remove reactions for this message
        messageReactions.remove(messageId);
        _saveReactions();

        Get.snackbar(
          'success'.tr,
          'Message deleted',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
      } else {
        // TODO: Delete from Firestore in Phase 2
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to delete message',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  String formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Search functionality
  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchQuery.value = '';
      filteredMessages.value = messages;
    }
  }

  void searchMessages(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMessages.value = messages;
    } else {
      filteredMessages.value = messages
          .where((msg) => msg.text.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Typing indicator
  void setTyping(bool typing) {
    isTyping.value = typing;
    // TODO: Send typing status to Firestore in Phase 2
  }

  // Simulate receiver typing (for demo)
  void simulateReceiverTyping() {
    if (isDemoMode.value) {
      isReceiverTyping.value = true;
      Future.delayed(Duration(seconds: 2), () {
        isReceiverTyping.value = false;
      });
    }
  }

  // Reactions
  Map<String, int> getMessageReactions(String messageId) {
    return messageReactions[messageId] ?? {};
  }

  void addReaction(String messageId, String emoji) {
    final reactions = Map<String, int>.from(messageReactions[messageId] ?? {});
    reactions[emoji] = (reactions[emoji] ?? 0) + 1;
    messageReactions[messageId] = reactions;
    messageReactions.refresh();

    // Save to storage
    _saveReactions();

    Get.snackbar(
      'Reaction Added',
      'You reacted with $emoji',
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 1),
    );

    // TODO: Save to Firestore in Phase 2
  }

  void removeReaction(String messageId, String emoji) {
    final reactions = Map<String, int>.from(messageReactions[messageId] ?? {});
    if (reactions.containsKey(emoji)) {
      reactions[emoji] = reactions[emoji]! - 1;
      if (reactions[emoji]! <= 0) {
        reactions.remove(emoji);
      }
    }
    messageReactions[messageId] = reactions;
    messageReactions.refresh();

    // Save to storage
    _saveReactions();

    // TODO: Save to Firestore in Phase 2
  }

  void _saveReactions() {
    final reactionsMap = messageReactions.map(
      (key, value) => MapEntry(key, value),
    );
    _storage.write('chat_reactions_$chatId', reactionsMap);
  }

  void _loadReactions() {
    final saved = _storage.read<Map>('chat_reactions_$chatId');
    if (saved != null) {
      messageReactions.value = saved.map(
        (key, value) =>
            MapEntry(key.toString(), Map<String, int>.from(value as Map)),
      );
    }
  }

  // Image message
  Future<void> sendImageMessage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image == null) return;

      isSending.value = true;

      if (isDemoMode.value) {
        // In demo mode, use local file path
        final message = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          receiverId: receiverId,
          text: '',
          imageUrl: image.path, // Local path for demo
          createdAt: DateTime.now(),
          isRead: false,
          type: MessageType.image,
        );

        messages.add(message);
        messages.refresh();

        if (searchQuery.value.isEmpty) {
          filteredMessages.value = messages;
        }

        _saveMessages();

        Get.snackbar(
          'success'.tr,
          'Image sent',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
      } else {
        // TODO: Upload to Firebase Storage
        // final storageRef = FirebaseStorage.instance
        //     .ref()
        //     .child('chat_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        // await storageRef.putFile(File(image.path));
        // final imageUrl = await storageRef.getDownloadURL();
        // Then send message with imageUrl

        Get.snackbar(
          'Coming Soon',
          'Firebase image upload will be available in Phase 2',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to send image: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Voice message
  Future<void> sendVoiceMessage() async {
    try {
      final AudioRecorder recorder = AudioRecorder();

      // Check permission
      if (!await recorder.hasPermission()) {
        Get.snackbar(
          'Permission Required',
          'Microphone permission is required to record voice messages',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        return;
      }

      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      // Show recording dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Row(
              children: [
                Icon(Icons.mic, color: Colors.red),
                SizedBox(width: 12),
                Text('Recording...'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.graphic_eq, size: 48, color: Colors.red),
                SizedBox(height: 16),
                Text('Tap Stop when finished', style: TextStyle(fontSize: 14)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await recorder.stop();
                  Get.back();
                },
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final path = await recorder.stop();
                  Get.back();

                  if (path != null) {
                    _sendVoiceFile(path);
                  }
                },
                child: Text('Stop & Send'),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      // Start recording
      await recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to record: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> _sendVoiceFile(String voicePath) async {
    try {
      isSending.value = true;

      if (isDemoMode.value) {
        // In demo mode, use local file path
        final message = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          receiverId: receiverId,
          text: '',
          voiceUrl: voicePath, // Local path for demo
          createdAt: DateTime.now(),
          isRead: false,
          type: MessageType.voice,
        );

        messages.add(message);
        messages.refresh();

        if (searchQuery.value.isEmpty) {
          filteredMessages.value = messages;
        }

        _saveMessages();

        Get.snackbar(
          'success'.tr,
          'Voice message sent',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
      } else {
        // TODO: Upload to Firebase Storage
        // final storageRef = FirebaseStorage.instance
        //     .ref()
        //     .child('chat_voices/${DateTime.now().millisecondsSinceEpoch}.m4a');
        // await storageRef.putFile(File(voicePath));
        // final voiceUrl = await storageRef.getDownloadURL();
        // Then send message with voiceUrl

        Get.snackbar(
          'Coming Soon',
          'Firebase voice upload will be available in Phase 2',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to send voice message: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Document message
  Future<void> sendDocumentMessage() async {
    try {
      isSending.value = true;

      // Use real file picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'txt',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
        ],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        // User cancelled
        isSending.value = false;
        return;
      }

      final file = result.files.first;
      final fileName = file.name;
      final fileSize = file.size;
      final filePath = file.path;

      // Validate file size (max 10MB)
      if (fileSize > 10 * 1024 * 1024) {
        Get.snackbar(
          'File Too Large',
          'Please select a file smaller than 10MB',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
        isSending.value = false;
        return;
      }

      // Save document info locally
      final message = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: chatId,
        senderId: currentUserId,
        senderName: currentUserName,
        receiverId: receiverId,
        text: fileName,
        createdAt: DateTime.now(),
        isRead: false,
        type: MessageType.document,
        documentUrl: filePath,
        documentName: fileName,
        documentSize: fileSize,
      );

      messages.add(message);
      filteredMessages.value = messages;
      _saveMessages();

      Get.snackbar(
        'success'.tr,
        'Document sent',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to send document: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Location message
  Future<void> sendLocationMessage() async {
    try {
      isSending.value = true;

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'Permission Required',
            'Location permission is required to share your location',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
          );
          isSending.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Permission Denied',
          'Please enable location permission in settings',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );
        isSending.value = false;
        return;
      }

      // Show loading dialog
      Get.dialog(
        Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      Get.back(); // Close loading dialog

      final latitude = position.latitude;
      final longitude = position.longitude;
      final locationText = 'Location: $latitude, $longitude';

      if (isDemoMode.value) {
        // Demo mode: save location locally
        final message = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          chatId: chatId,
          senderId: currentUserId,
          senderName: currentUserName,
          receiverId: receiverId,
          text: locationText,
          createdAt: DateTime.now(),
          isRead: false,
          type: MessageType.location,
          latitude: latitude,
          longitude: longitude,
        );

        messages.add(message);
        filteredMessages.value = messages;
        _saveMessages();

        Get.snackbar(
          'success'.tr,
          'Location shared',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 1),
        );
      } else {
        // TODO: Send location to Firebase
        // final message = MessageModel(
        //   id: DateTime.now().millisecondsSinceEpoch.toString(),
        //   senderId: currentUserId,
        //   receiverId: receiverId,
        //   message: locationText,
        //   timestamp: DateTime.now(),
        //   isRead: false,
        //   type: MessageType.location,
        //   latitude: latitude,
        //   longitude: longitude,
        // );
        // await _firebaseService.sendMessage(chatId, message);

        Get.snackbar(
          'Coming Soon',
          'Firebase location sharing will be available in Phase 2',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close loading dialog if open
      }
      Get.snackbar(
        'error'.tr,
        'Failed to get location: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
      );
    } finally {
      isSending.value = false;
    }
  }

  // Show group members dialog
  void showGroupMembers() {
    if (!isGroup || memberNames.isEmpty) return;

    final memberList = groupMembers
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
                          receiverName,
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
                final memberId = groupMembers[index];
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

  @override
  void onClose() {
    setTyping(false);
    super.onClose();
  }
}
