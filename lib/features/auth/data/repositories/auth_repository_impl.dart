import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> login(String email, String password) async {
    final userModel = await remoteDatasource.login(email, password);
    return userModel.toEntity();
  }

  @override
  Future<User> register(String name, String email, String password) async {
    final userModel = await remoteDatasource.register(name, email, password);
    return userModel.toEntity();
  }

  @override
  Future<void> signOut() async {
    await remoteDatasource.signOut();
  }

  @override
  Future<User> signInWithGoogle() async {
    final userModel = await remoteDatasource.signInWithGoogle();
    return userModel.toEntity();
  }

  @override
  Stream<User?> get authStateChanges => remoteDatasource.authStateChanges;
}
