import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final List<Widget>? actions;
  final VoidCallback? onActionPressed;
  final String? actionTooltip;
  final IconData? actionIcon;
  final bool showBackButton;
  final Color? backgroundColor;
  final double elevation;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.icon,
    this.actions,
    this.onActionPressed,
    this.actionTooltip,
    this.actionIcon,
    this.showBackButton = true,
    this.backgroundColor,
    this.elevation = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        backgroundColor ?? (isDark ? Color(0xFF121212) : Colors.white);

    return AppBar(
      elevation: elevation,
      backgroundColor: bgColor,
      automaticallyImplyLeading: showBackButton,
      iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Text(
            title.tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.3,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      actions:
          actions ??
          (onActionPressed != null
              ? [
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).primaryColor.withOpacity(isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        actionIcon ?? Icons.add_circle_outline,
                        color: Theme.of(context).primaryColor,
                      ),
                      onPressed: onActionPressed,
                      tooltip: actionTooltip?.tr ?? '',
                    ),
                  ),
                ]
              : null),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
