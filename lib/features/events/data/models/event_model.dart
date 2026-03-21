import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String cityId;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String userId;
  final EventStatus status;
  final String? externalUrl;
  final int attendingCount;

  const EventModel({
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

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      category: event.category,
      cityId: event.cityId,
      locationAddress: event.locationAddress,
      latitude: event.latitude,
      longitude: event.longitude,
      imageUrl: event.imageUrl,
      userId: event.userId,
      status: event.status,
      externalUrl: event.externalUrl,
      attendingCount: event.attendingCount,
    );
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      date: DateTime.parse(data['date'] as String),
      category: data['category'] as String,
      cityId: data['cityId'] as String,
      locationAddress: data['locationAddress'] as String,
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      userId: data['createdBy'] as String,
      status: EventStatus.fromString(data['status'] as String),
      externalUrl: data['externalUrl'] as String?,
      attendingCount: data['attendingCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'cityId': cityId,
      'locationAddress': locationAddress,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'createdBy': userId,
      'status': status.name,
      'externalUrl': externalUrl,
      'attendingCount': attendingCount,
    };
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      category: category,
      cityId: cityId,
      locationAddress: locationAddress,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      userId: userId,
      status: status,
      externalUrl: externalUrl,
      attendingCount: attendingCount,
    );
  }
}
