import 'package:equatable/equatable.dart';

class LocationInfo extends Equatable {
  final double lat;
  final double lng;
  final String cityName;
  final String address;

  const LocationInfo({
    required this.lat,
    required this.lng,
    required this.cityName,
    required this.address,
  });

  @override
  List<Object?> get props => [lat, lng, cityName, address];
}
