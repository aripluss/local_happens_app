import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> getEvents();
  Future<Event> getEventById(String id);
  Future<Event> createEvent(Event event);
  Future<Event> updateEvent(Event event);
  Future<void> deleteEvent(Event event);
  Future<List<Event>> filterEvents(String query);
}
