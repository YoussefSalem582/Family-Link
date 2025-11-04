import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final double size;
  final VoidCallback? onTap;

  const AvatarWidget({
    Key? key,
    required this.name,
    this.photoUrl,
    this.size = 50,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: _getColorFromName(name),
        backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
            ? NetworkImage(photoUrl!)
            : null,
        child: photoUrl == null || photoUrl!.isEmpty
            ? Text(
                _getInitials(name),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size / 2.5,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.isEmpty) return '?';

    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    }

    return (nameParts[0][0] + nameParts[nameParts.length - 1][0]).toUpperCase();
  }

  Color _getColorFromName(String name) {
    final colors = [
      Color(0xFF6750A4),
      Color(0xFF625B71),
      Color(0xFF7D5260),
      Color(0xFF00897B),
      Color(0xFF43A047),
      Color(0xFFFB8C00),
      Color(0xFFE53935),
      Color(0xFF3949AB),
    ];

    int hash = name.codeUnits.fold(0, (prev, curr) => prev + curr);
    return colors[hash % colors.length];
  }
}
