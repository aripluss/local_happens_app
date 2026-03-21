import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/auth/domain/entities/user_role.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_state.dart';

class NavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const NavigationBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final isAdmin = authState is Authenticated
        ? authState.user.role == UserRole.admin
        : false;

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      destinations: [
        const NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Події',
        ),
        const NavigationDestination(
          icon: Icon(Icons.map_outlined),
          label: 'Мапа',
        ),
        const NavigationDestination(
          icon: Icon(Icons.favorite_border),
          label: 'Обране',
        ),
        const NavigationDestination(
          icon: Icon(Icons.person_outline_outlined),
          label: 'Профіль',
        ),
        if (isAdmin)
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            label: 'Адмін',
          ),
      ],
    );
  }
}
