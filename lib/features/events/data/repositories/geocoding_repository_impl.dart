import 'package:geocoding/geocoding.dart';
import 'package:local_happens/features/events/domain/entities/location_info.dart';
import 'package:local_happens/features/events/domain/repositories/geocoding_repository.dart';

class GeocodingRepositoryImpl implements GeocodingRepository {
  @override
  Future<LocationInfo> resolveLocation(double lat, double lng) async {
    await setLocaleIdentifier('uk_UA');
    final placemarks = await placemarkFromCoordinates(lat, lng);
    final place = placemarks.first;

    final cityName = place.locality ?? '';
    final street = place.street ?? '';
    final name = place.name ?? '';
    final address = '$street $name'.trim();

    return LocationInfo(
      lat: lat,
      lng: lng,
      cityName: cityName,
      address: address,
    );
  }
}
