import '../../domain/entities/event.dart';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String category;
  final String city;
  final String locationName;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String createdBy;

  const EventModel({
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

  factory EventModel.fromEntity(Event event) {
    return EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      date: event.date,
      category: event.category,
      city: event.city,
      locationName: event.locationName,
      latitude: event.latitude,
      longitude: event.longitude,
      imageUrl: event.imageUrl,
      createdBy: event.createdBy,
    );
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      category: json['category'],
      city: json['city'],
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      createdBy: json['createdBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'category': category,
      'city': city,
      'locationName': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
    };
  }

  Event toEntity() {
    return Event(
      id: id,
      title: title,
      description: description,
      date: date,
      category: category,
      city: city,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      imageUrl: imageUrl,
      createdBy: createdBy,
    );
  }
}
