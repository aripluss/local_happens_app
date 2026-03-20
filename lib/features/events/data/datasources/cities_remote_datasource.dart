import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_happens/features/events/data/models/city_model.dart';

abstract class CitiesRemoteDatasource {
  Future<CityModel?> findByNormalizedName(String normalizedName);
  Future<CityModel> createCity(String name);
  Future<Set<CityModel>> getCitiesByIds(Set<String> ids);
}

class CitiesRemoteDatasourceImpl implements CitiesRemoteDatasource {
  final FirebaseFirestore firestore;

  CitiesRemoteDatasourceImpl({required this.firestore});

  @override
  Future<CityModel?> findByNormalizedName(String normalizedName) async {
    final snapshot = await firestore
        .collection('cities')
        .where('normalizedName', isEqualTo: normalizedName)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) return null;
    return CityModel.fromFirestore(snapshot.docs.first);
  }

  @override
  Future<CityModel> createCity(String name) async {
    final normalizedName = name.trim().toLowerCase();
    final docRef = await firestore.collection('cities').add({
      'name': name,
      'normalizedName': normalizedName,
    });
    return CityModel(id: docRef.id, name: name, normalizedName: normalizedName);
  }

  @override
  Future<Set<CityModel>> getCitiesByIds(Set<String> ids) async {
    return await firestore
        .collection('cities')
        .where(FieldPath.documentId, whereIn: ids)
        .get()
        .then((snapshot) {
      return snapshot.docs.fold<Set<CityModel>>({}, (acc, doc) {
        acc.add(CityModel.fromFirestore(doc));
        return acc;
      });
    });
  }
}
