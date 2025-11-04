import 'package:flutter/material.dart';

class MapControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const MapControlButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(icon: Icon(icon), onPressed: onPressed, iconSize: 24),
    );
  }
}
