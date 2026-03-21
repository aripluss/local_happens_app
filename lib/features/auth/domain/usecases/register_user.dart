import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<User> call(RegisterParams params) async {
    return await repository.register(params.name, params.email, params.password);
  }
}

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({required this.name, required this.email, required this.password});
}
