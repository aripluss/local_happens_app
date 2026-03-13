import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/auth/domain/entities/user.dart';
import 'package:local_happens/features/auth/domain/usecases/get_current_user.dart';
import 'package:local_happens/features/auth/domain/usecases/sign_in_with_google_user.dart';
import 'package:local_happens/features/auth/domain/usecases/sign_out_user.dart';
import 'package:local_happens/features/auth/domain/usecases/login_user.dart';
import 'package:local_happens/features/auth/domain/usecases/register_user.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final SignInWithGoogleUser signInWithGoogleUser;
  final SignOutUser signOutUser;
  final GetCurrentUser getCurrentUser;

  AuthCubit({
    required this.loginUser,
    required this.registerUser,
    required this.signInWithGoogleUser,
    required this.signOutUser,
    required this.getCurrentUser,
  }) : super(AuthInitial());

  Future<void> checkAuth() async {
    emit(AuthLoading());

    try {
      final user = await getCurrentUser(NoParams());

      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUser(
        LoginParams(email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await registerUser(
        RegisterParams(name: name, email: email, password: password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await signInWithGoogleUser(NoParams());
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await signOutUser(NoParams());
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<User?> getUser() async {
    return await getCurrentUser(NoParams());
  }
}
