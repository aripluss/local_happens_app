import 'package:local_happens/features/events/domain/entities/city.dart';
import 'package:local_happens/features/events/domain/repositories/cities_repository.dart';

/// Looks up a city by normalised name; creates it in the cities collection
/// if it does not exist yet. Returns the resolved [City].
class GetOrCreateCity {
  final CitiesRepository repository;

  GetOrCreateCity(this.repository);

  Future<City> call(String cityName) async {
    final normalized = cityName.trim().toLowerCase();
    final existing = await repository.findByNormalizedName(normalized);
    if (existing != null) return existing;
    return repository.createCity(cityName.trim());
  }
}
