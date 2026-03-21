// import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/auth/domain/entities/user.dart';
import 'package:local_happens/features/auth/domain/repositories/auth_repository.dart';

class AuthStateChanges {
  final AuthRepository repository;

  AuthStateChanges(this.repository);

  Stream<User?> call() {
    return repository.authStateChanges;
  }
}

// class AuthStateChanges implements UseCase<Stream<User?>, NoParams> {
//   final AuthRepository repository;

//   AuthStateChanges(this.repository);

//   @override
//   Future<Stream<User?>> call(NoParams params) async {
//     return repository.authStateChanges;
//   }
// }