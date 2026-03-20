import 'package:local_happens/features/events/domain/entities/city.dart';

abstract class CitiesRepository {
  Future<City?> findByNormalizedName(String normalizedName);

  Future<City> createCity(String name);

  Future<Set<City>> getCitiesByIds(Set<String> ids);
}
