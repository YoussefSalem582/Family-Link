import 'package:flutter/material.dart';
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
    return Row(
      children: [
        // text and Icon with Gradient Background
        Container(
          padding: EdgeInsets.all(8),
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
          ),
          child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
        ),
        SizedBox(width: 12),
        // button
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (actionText != null && onActionPressed != null)
          CustomButton(
            text: actionText!,
            onPressed: onActionPressed!,
            icon: actionIcon,
            backgroundColor: Colors.white,
            textColor: Theme.of(context).primaryColor,
            borderColor: Theme.of(context).primaryColor.withOpacity(0.3),
          ),
      ],
    );
  }
}
