import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String city;
  final DateTime date;
  final String locationName;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String createdBy;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.city,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    category,
    city,
    locationName,
    latitude,
    longitude,
    imageUrl,
    createdBy,
  ];
}
