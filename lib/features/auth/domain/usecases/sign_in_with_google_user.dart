import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignInWithGoogleUser implements UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUser(this.repository);

  @override
  Future<User> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
