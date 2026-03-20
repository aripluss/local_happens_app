import 'package:local_happens/features/auth/data/models/user_model.dart';

abstract class UsersRepository {
  Future<Set<UserModel>> getUsersByIds(Set<String> ids);
}