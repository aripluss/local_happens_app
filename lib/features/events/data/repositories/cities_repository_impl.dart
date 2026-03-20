import 'package:local_happens/features/events/data/datasources/cities_remote_datasource.dart';
import 'package:local_happens/features/events/domain/entities/city.dart';
import 'package:local_happens/features/events/domain/repositories/cities_repository.dart';

class CitiesRepositoryImpl implements CitiesRepository {
  final CitiesRemoteDatasource datasource;

  CitiesRepositoryImpl({required this.datasource});

  @override
  Future<City?> findByNormalizedName(String normalizedName) async {
    final model = await datasource.findByNormalizedName(normalizedName);
    return model?.toEntity();
  }

  @override
  Future<City> createCity(String name) async {
    final model = await datasource.createCity(name);
    return model.toEntity();
  }

  @override
  Future<Set<City>> getCitiesByIds(Set<String> ids) async {
    final models = await datasource.getCitiesByIds(ids);
    return models.map((model) => model.toEntity()).toSet();
  }
}
