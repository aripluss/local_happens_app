import 'package:local_happens/features/events/domain/entities/city.dart';
import 'package:local_happens/features/events/domain/repositories/cities_repository.dart';

class GetCitiesByIds {
  final CitiesRepository citiesRepository;

  GetCitiesByIds(this.citiesRepository);

  Future<Set<City>> call(Set<String> ids) async {
    return await citiesRepository.getCitiesByIds(ids);
  }
}
