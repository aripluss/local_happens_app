import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/auth/domain/entities/user.dart';
import 'package:local_happens/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<User?> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
