import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_button.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final IconData? actionIcon;
  final Color? iconColor;
  final Gradient? iconGradient;

  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.actionText,
    this.onActionPressed,
    this.actionIcon,
    this.iconColor,
    this.iconGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        // Icon with Gradient Background
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient:
                iconGradient ??
                LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        // Title text with localization support
        Expanded(
          child: Text(
            title.tr,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        if (actionText != null && onActionPressed != null)
          CustomButton(
            text: actionText!.tr,
            onPressed: onActionPressed!,
            icon: actionIcon,
            backgroundColor: isDark
                ? Theme.of(context).colorScheme.surface
                : Colors.white,
            textColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(
              context,
            ).primaryColor.withOpacity(isDark ? 0.5 : 0.3),
          ),
      ],
    );
  }
}
