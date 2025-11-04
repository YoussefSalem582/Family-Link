import 'package:flutter/material.dart';
import '../../../../data/models/user_model.dart';
import '../../../../widgets/avatar_widget.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              AvatarWidget(name: user.name, photoUrl: user.photoUrl, size: 100),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Text(
          user.name,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.email, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text(user.email, style: TextStyle(color: Colors.grey)),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey),
            SizedBox(width: 4),
            Text(user.location, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}
