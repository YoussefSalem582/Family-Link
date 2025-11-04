import 'package:flutter/material.dart';

class MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;

  const MapControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final defaultBg = isDark ? Color(0xFF2A2A2A) : Colors.white;
    final disabledBg = isDark ? Color(0xFF1E1E1E) : Colors.grey[300];
    final defaultIconColor = isDark ? Colors.grey[300] : Colors.grey[800];
    final disabledIconColor = isDark ? Colors.grey[700] : Colors.grey[500];
    final shadowOpacity = isDark ? 0.4 : 0.15;

    return Container(
      decoration: BoxDecoration(
        color: isDisabled ? disabledBg : (backgroundColor ?? defaultBg),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(shadowOpacity),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: isDisabled
                  ? disabledIconColor
                  : (iconColor ?? defaultIconColor),
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
