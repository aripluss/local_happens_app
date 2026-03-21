import 'package:local_happens/features/auth/data/models/user_model.dart';
import 'package:local_happens/features/events/data/datasources/users_remote_datasource.dart';
import 'package:local_happens/features/events/domain/repositories/users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDatasource usersRemoteDatasource;

  UsersRepositoryImpl(this.usersRemoteDatasource);

  @override
  Future<Set<UserModel>> getUsersByIds(Set<String> ids) async {
    return await usersRemoteDatasource.getUsersByIds(ids);
  }
}