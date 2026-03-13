
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});

  @override
  Future<User> login(String email, String password) async {
    return await remoteDatasource.login(email, password);
  }

  @override
  Future<User> register(String name, String email, String password) async {
    return await remoteDatasource.register(name, email, password);
  }
  
  @override
  Future<User?> getCurrentUser() async{
    final user = await remoteDatasource.getCurrentUser();
    if (user == null) {
      return null;
    }
    return user.toEntity();
  }
  
  @override
  Future<void> signOut() {
    return remoteDatasource.signOut();
  }
  
  @override
  Future<User> signInWithGoogle() {
    return remoteDatasource.signInWithGoogle();
  }

  @override
  Stream<User?> get authStateChanges => remoteDatasource.authStateChanges;
}
