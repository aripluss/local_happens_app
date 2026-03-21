import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_happens/features/events/domain/entities/city.dart';

class CityModel {
  final String id;
  final String name;
  final String normalizedName;

  const CityModel({
    required this.id,
    required this.name,
    required this.normalizedName,
  });

  factory CityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CityModel(
      id: doc.id,
      name: data['name'] as String,
      normalizedName: data['normalizedName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'normalizedName': normalizedName,
    };
  }

  City toEntity() {
    return City(id: id, name: name, normalizedName: normalizedName);
  }
}
