import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_happens/features/events/data/models/event_model.dart';

abstract class EventRemoteDatasource {
  Future<List<EventModel>> getEvents();
  Future<EventModel> createEvent(EventModel event);
  Future<EventModel> updateEvent(EventModel event);
  Future<void> deleteEvent(String id);
  Future<List<EventModel>> filterEvents(String category);
  Future<EventModel> getEventById(String id);
}

class EventRemoteDatasourceImpl implements EventRemoteDatasource {
  final FirebaseFirestore firestore;
  EventRemoteDatasourceImpl({required this.firestore});

  @override
  Future<List<EventModel>> getEvents() async {
    final snapshot = await firestore.collection('events').get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<EventModel> createEvent(EventModel event) async {
    await firestore.collection('events').add(event.toJson());
    return event;
  }

  @override
  Future<EventModel> updateEvent(EventModel event) async {
    await firestore.collection('events').doc(event.id).update(event.toJson());
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    await firestore.collection('events').doc(id).delete();
  }

  @override
  Future<List<EventModel>> filterEvents(String category) async {
    final snapshot = await firestore.collection('events').where('category', isEqualTo: category).get();
    return snapshot.docs.map((doc) => EventModel.fromJson(doc.data())).toList();
  }

  @override
  Future<EventModel> getEventById(String id) async {
    final snapshot = await firestore.collection('events').doc(id).get();
    return EventModel.fromJson(snapshot.data()!);
  }
}
