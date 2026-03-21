import 'package:flutter/material.dart';
import 'package:local_happens/features/auth/domain/entities/user.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 32,
        backgroundImage: user.avatarUrl.isNotEmpty
            ? NetworkImage(user.avatarUrl)
            : null,
        child: user.avatarUrl.isEmpty
            ? Text(user.name[0], style: const TextStyle(fontSize: 18))
            : null,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  }
}
