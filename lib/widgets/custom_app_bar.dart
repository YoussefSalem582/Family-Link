import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'avatar_widget.dart';

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
  final String? avatarName;
  final String? avatarPhotoUrl;
  final VoidCallback? onTitleTap;

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
    this.avatarName,
    this.avatarPhotoUrl,
    this.onTitleTap,
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
      titleSpacing: avatarName != null ? 0 : null,
      title: GestureDetector(
        onTap: onTitleTap,
        child: Row(
          children: [
            // Show avatar or icon
            if (avatarName != null)
              AvatarWidget(
                name: avatarName!,
                photoUrl: avatarPhotoUrl,
                size: 40,
              )
            else
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.tr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: avatarName != null ? 16 : 20,
                      letterSpacing: 0.3,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (avatarName != null && onTitleTap != null)
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
        // Show action icon if provided
        if (onActionPressed != null)
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
        // Show additional actions if provided
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
