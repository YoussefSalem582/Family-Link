import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../../data/models/message_model.dart';
import '../../../../widgets/avatar_widget.dart';
import '../../viewmodel/chat_viewmodel.dart';
import 'message_reactions.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final ChatViewModel controller;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bubbleColor = isMe
        ? Theme.of(context).primaryColor
        : (isDark ? Color(0xFF2A2A2A) : Colors.grey[200]);
    final textColor = isMe
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);
    final timeColor = isMe
        ? Colors.white.withOpacity(0.8)
        : (isDark ? Colors.grey[500] : Colors.grey[600]);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () => _showMessageOptions(context),
        child: Container(
          margin: EdgeInsets.only(bottom: 8),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar for received messages
              if (!isMe) ...[
                AvatarWidget(
                  name: message.senderName,
                  photoUrl: message.senderPhotoUrl,
                  size: 32,
                ),
                SizedBox(width: 8),
              ],

              // Message bubble
              Flexible(
                child: Column(
                  crossAxisAlignment: isMe
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          topLeft: isMe
                              ? Radius.circular(16)
                              : Radius.circular(4),
                          topRight: isMe
                              ? Radius.circular(4)
                              : Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sender name for received messages
                          if (!isMe) ...[
                            Text(
                              message.senderName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 4),
                          ],

                          // Message content based on type
                          _buildMessageContent(context, textColor, isDark),

                          SizedBox(height: 4),

                          // Time
                          Text(
                            controller.formatMessageTime(message.createdAt),
                            style: TextStyle(fontSize: 11, color: timeColor),
                          ),
                        ],
                      ),
                    ),

                    // Reactions
                    Obx(() {
                      final reactions = controller.getMessageReactions(
                        message.id,
                      );
                      if (reactions.isEmpty) return SizedBox.shrink();

                      return MessageReactions(
                        reactions: reactions,
                        onReactionTap: (emoji) =>
                            controller.removeReaction(message.id, emoji),
                      );
                    }),
                  ],
                ),
              ),

              // Avatar for sent messages
              if (isMe) ...[
                SizedBox(width: 8),
                AvatarWidget(name: message.senderName, size: 32),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageContent(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage(context, textColor, isDark);
      case MessageType.voice:
        return _buildVoiceMessage(context, textColor, isDark);
      case MessageType.document:
        return _buildDocumentMessage(context, textColor, isDark);
      case MessageType.location:
        return _buildLocationMessage(context, textColor, isDark);
      case MessageType.text:
        return Text(
          message.text,
          style: TextStyle(fontSize: 15, color: textColor, height: 1.4),
        );
    }
  }

  Widget _buildImageMessage(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.imageUrl != null)
          GestureDetector(
            onTap: () {
              // Show full screen image
              Get.dialog(
                Dialog(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(child: _buildImageWidget(isDark)),
                      Positioned(
                        top: 40,
                        right: 20,
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 32,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildImageWidget(isDark, width: 200, height: 200),
            ),
          ),
        if (message.text.isNotEmpty) ...[
          SizedBox(height: 8),
          Text(
            message.text,
            style: TextStyle(fontSize: 15, color: textColor, height: 1.4),
          ),
        ],
      ],
    );
  }

  Widget _buildImageWidget(bool isDark, {double? width, double? height}) {
    final imageUrl = message.imageUrl!;

    // Check if it's a local file path (demo mode)
    if (imageUrl.startsWith('/')) {
      return Image.file(
        File(imageUrl),
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width ?? 300,
            height: height ?? 300,
            color: isDark ? Colors.grey[800] : Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Image not found',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    }

    // Network image (Firebase URL)
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width ?? 300,
          height: height ?? 300,
          color: isDark ? Colors.grey[800] : Colors.grey[300],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? 300,
          height: height ?? 300,
          color: isDark ? Colors.grey[800] : Colors.grey[300],
          child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
        );
      },
    );
  }

  Widget _buildVoiceMessage(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play button
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.play_arrow, color: textColor, size: 24),
              padding: EdgeInsets.zero,
              onPressed: () {
                // TODO: Play voice message
                Get.snackbar(
                  'Voice Player',
                  'Voice playback will be available soon',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: Duration(seconds: 2),
                );
              },
            ),
          ),
          SizedBox(width: 12),
          // Voice wave indicator
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                    20,
                    (index) => Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 1),
                        height: (index % 3 + 1) * 8.0,
                        decoration: BoxDecoration(
                          color: textColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  '0:15', // TODO: Get actual duration from file
                  style: TextStyle(
                    fontSize: 11,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentMessage(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    final fileName = message.documentName ?? 'Document';
    final fileSize = message.documentSize != null
        ? _formatFileSize(message.documentSize!)
        : 'Unknown size';
    final fileExtension = fileName.split('.').last.toUpperCase();

    return InkWell(
      onTap: () {
        // TODO: Implement document viewer/opener
        Get.snackbar(
          'Document',
          'Document viewer will be available soon',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800]!.withOpacity(0.3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Document icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getDocumentColor(fileExtension).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getDocumentIcon(fileExtension),
                color: _getDocumentColor(fileExtension),
                size: 28,
              ),
            ),
            SizedBox(width: 12),
            // Document info
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$fileExtension • $fileSize',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            // Download icon
            Icon(
              Icons.download_outlined,
              color: textColor.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationMessage(
    BuildContext context,
    Color textColor,
    bool isDark,
  ) {
    final latitude = message.latitude ?? 0.0;
    final longitude = message.longitude ?? 0.0;

    return InkWell(
      onTap: () {
        // TODO: Open in maps app
        Get.snackbar(
          'Location',
          'Opening location: $latitude, $longitude',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 250,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800]!.withOpacity(0.3) : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Map placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.map_outlined,
                      size: 64,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                  Center(
                    child: Icon(Icons.location_on, size: 48, color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            // Location info
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: textColor.withOpacity(0.7),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Lat: ${latitude.toStringAsFixed(6)}, Long: ${longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withOpacity(0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Tap to open in maps',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  IconData _getDocumentIcon(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDocumentColor(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return Colors.red;
      case 'doc':
      case 'docx':
        return Colors.blue;
      case 'xls':
      case 'xlsx':
        return Colors.green;
      case 'ppt':
      case 'pptx':
        return Colors.orange;
      case 'txt':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  void _showMessageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // React to message
            ListTile(
              leading: Icon(Icons.add_reaction_outlined, color: Colors.amber),
              title: Text('Add Reaction'),
              onTap: () {
                Get.back();
                _showReactionPicker(context);
              },
            ),

            // Copy text
            if (message.type == MessageType.text)
              ListTile(
                leading: Icon(Icons.copy_outlined, color: Colors.blue),
                title: Text('Copy Text'),
                onTap: () {
                  Get.back();
                  // TODO: Copy to clipboard
                  Get.snackbar(
                    'Copied',
                    'Message copied to clipboard',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 1),
                  );
                },
              ),

            // Delete (only for own messages)
            if (isMe)
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Delete Message'),
                onTap: () {
                  Get.back();
                  controller.deleteMessage(message.id);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showReactionPicker(BuildContext context) {
    final reactions = ['❤️', '👍', '😂', '😮', '😢', '🙏', '🎉', '🔥'];

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'React to message',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: reactions.map((emoji) {
                return InkWell(
                  onTap: () {
                    Get.back();
                    controller.addReaction(message.id, emoji);
                  },
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(emoji, style: TextStyle(fontSize: 28)),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
