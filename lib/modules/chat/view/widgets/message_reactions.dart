import 'package:flutter/material.dart';

class MessageReactions extends StatelessWidget {
  final Map<String, int> reactions;
  final Function(String emoji) onReactionTap;

  const MessageReactions({
    Key? key,
    required this.reactions,
    required this.onReactionTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reactions.isEmpty) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.only(top: 4),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: reactions.entries.map((entry) {
          return GestureDetector(
            onTap: () => onReactionTap(entry.key),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(entry.key, style: TextStyle(fontSize: 14)),
                  if (entry.value > 1) ...[
                    SizedBox(width: 4),
                    Text(
                      '${entry.value}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
