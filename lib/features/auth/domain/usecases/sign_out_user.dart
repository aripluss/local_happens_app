import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SignOutUser implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUser(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return await repository.signOut();
  }
}