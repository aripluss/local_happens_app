import 'package:equatable/equatable.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String description;
  final String category;
  final String cityId;
  final DateTime date;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String userId;
  final EventStatus status;
  final String? externalUrl;
  final int attendingCount;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.cityId,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.userId,
    required this.status,
    this.externalUrl,
    this.attendingCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    date,
    category,
    cityId,
    locationAddress,
    latitude,
    longitude,
    imageUrl,
    userId,
    status,
    externalUrl,
    attendingCount,
  ];
}
