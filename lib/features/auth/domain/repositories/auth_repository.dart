import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String name, String email, String password);
  Future<User?> getCurrentUser();
  Future<void> signOut();
  Future<User> signInWithGoogle();
  Stream<User?> get authStateChanges;
}
