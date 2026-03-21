import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_happens/features/auth/data/models/user_model.dart';

abstract class UsersRemoteDatasource {
  Future<Set<UserModel>> getUsersByIds(Set<String> ids);
}

class UsersRemoteDatasourceImpl implements UsersRemoteDatasource {
  final FirebaseFirestore firestore;

  UsersRemoteDatasourceImpl({required this.firestore});

  @override
  Future<Set<UserModel>> getUsersByIds(Set<String> ids) async {
    return await firestore
        .collection('users')
        .where(FieldPath.documentId, whereIn: ids)
        .get()
        .then((snapshot) {
      return snapshot.docs.fold<Set<UserModel>>({}, (acc, doc) {
        acc.add(UserModel.fromJson(doc.data()));
        return acc;
      });
    });
  }
}