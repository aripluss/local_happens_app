
import 'package:local_happens/features/auth/data/models/user_model.dart';
import 'package:local_happens/features/events/domain/repositories/users_repository.dart';

class GetUsersByIds {
  final UsersRepository usersRepository;

  GetUsersByIds(this.usersRepository);

  Future<Set<UserModel>> call(Set<String> ids) async {
    return await usersRepository.getUsersByIds(ids);
  }
}