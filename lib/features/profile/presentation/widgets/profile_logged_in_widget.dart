import 'package:flutter/material.dart';
import 'package:local_happens/features/auth/domain/entities/user.dart';
import 'package:local_happens/features/profile/presentation/widgets/profile_actions_row_widget.dart';
import 'package:local_happens/features/profile/presentation/widgets/profile_events_widget.dart';
import 'package:local_happens/features/profile/presentation/widgets/profile_tile_widget.dart';

class ProfileLoggedInWidget extends StatelessWidget {
  final User user;
  const ProfileLoggedInWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileTileWidget(user: user),
            const SizedBox(height: 32),
            ProfileActionsRowWidget(),
            const SizedBox(height: 32),
            ProfileEventsWidget(),
          ],
        ),
      ),
    );
  }
}
