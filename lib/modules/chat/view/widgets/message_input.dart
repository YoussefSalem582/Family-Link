import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/chat_viewmodel.dart';
import 'attachment_options_sheet.dart';

class MessageInput extends StatefulWidget {
  final ChatViewModel controller;

  const MessageInput({Key? key, required this.controller}) : super(key: key);

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final isTyping = _textController.text.isNotEmpty;
    widget.controller.setTyping(isTyping);
  }

  void _onFocusChanged() {
    // Handle focus changes if needed
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      widget.controller.sendMessage(text);
      _textController.clear();
      widget.controller.setTyping(false);
    }
  }

  void _sendImage() {
    widget.controller.sendImageMessage();
  }

  void _sendVoice() {
    widget.controller.sendVoiceMessage();
  }

  void _showAttachmentOptions() {
    AttachmentOptionsSheet.show(
      onImageTap: () {
        Get.back();
        _sendImage();
      },
      onDocumentTap: () {
        Get.back();
        widget.controller.sendDocumentMessage();
      },
      onLocationTap: () {
        Get.back();
        widget.controller.sendLocationMessage();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inputBg = isDark ? Color(0xFF2A2A2A) : Colors.grey[100];
    final borderColor = isDark ? Colors.grey[800] : Colors.grey[300];

    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? Color(0xFF1E1E1E) : Colors.white,
        border: Border(top: BorderSide(color: borderColor!, width: 1)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Typing indicator
            Obx(() {
              if (widget.controller.isReceiverTyping.value) {
                return Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        '${widget.controller.receiverName} is typing',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizedBox(width: 8),
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark ? Colors.grey[500]! : Colors.grey[600]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SizedBox.shrink();
            }),

            // Input row
            Row(
              children: [
                // Attachment options button
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: _showAttachmentOptions,
                  color: Theme.of(context).primaryColor,
                ),

                // Voice message button
                IconButton(
                  icon: Icon(Icons.mic_outlined),
                  onPressed: _sendVoice,
                  color: Theme.of(context).primaryColor,
                ),

                // Message input field
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputBg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: borderColor, width: 1),
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          _sendMessage();
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Send button
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: widget.controller.isSending.value
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: widget.controller.isSending.value
                          ? null
                          : _sendMessage,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
