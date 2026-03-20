import 'package:local_happens/features/events/domain/entities/location_info.dart';
import 'package:local_happens/features/events/domain/repositories/geocoding_repository.dart';

class ResolveLocationFromCoordinates {
  final GeocodingRepository repository;

  ResolveLocationFromCoordinates(this.repository);

  Future<LocationInfo> call(double lat, double lng) {
    return repository.resolveLocation(lat, lng);
  }
}
