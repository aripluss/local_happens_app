import 'package:local_happens/features/events/domain/entities/location_info.dart';

abstract class GeocodingRepository {
  Future<LocationInfo> resolveLocation(double lat, double lng);
}
