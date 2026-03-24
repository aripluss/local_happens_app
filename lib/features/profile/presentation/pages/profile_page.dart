import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/core/constants/app_text_styles.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_state.dart';
import 'package:local_happens/features/profile/presentation/widgets/profile_unauthenticated_widget.dart';
import 'package:local_happens/features/profile/presentation/widgets/profile_logged_in_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль', style: AppTextStyles.headline),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            return ProfileLoggedInWidget(user: state.user);
          } else {
            return const ProfileUnauthenticatedWidget();
          }
        },
      ),
    );
  }
}
