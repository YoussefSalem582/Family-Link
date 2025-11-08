import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/chat_viewmodel.dart';

class ChatSearchBar extends StatefulWidget {
  final ChatViewModel controller;

  const ChatSearchBar({Key? key, required this.controller}) : super(key: key);

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      if (!widget.controller.isSearching.value) return SizedBox.shrink();

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Color(0xFF1E1E1E) : Colors.white,
          border: Border(
            bottom: BorderSide(
              color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search messages...',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            widget.controller.searchMessages('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (query) {
                  widget.controller.searchMessages(query);
                  setState(() {});
                },
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                widget.controller.toggleSearch();
              },
            ),
          ],
        ),
      );
    });
  }
}
