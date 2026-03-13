import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../datasources/event_remote_datasource.dart';
import '../models/event_model.dart';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDatasource remoteDatasource;

  EventRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<Event>> getEvents() async {
    final models = await remoteDatasource.getEvents();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Event> createEvent(Event event) async {
    final eventModel = EventModel.fromEntity(event);
    final createdModel = await remoteDatasource.createEvent(eventModel);
    return createdModel.toEntity();
  }

  @override
  Future<void> deleteEvent(Event event) async {
    await remoteDatasource.deleteEvent(event.id);
  }

  @override
  Future<Event> getEventById(String id) async {
    // TODO: implement getEventById
    throw UnimplementedError();
  }

  @override
  Future<Event> updateEvent(Event event) {
    // TODO: implement updateEvent
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> filterEvents(String query) {
    // TODO: implement filterEvents
    throw UnimplementedError();
  }
}
