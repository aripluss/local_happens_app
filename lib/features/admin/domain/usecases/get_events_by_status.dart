import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class GetEventsByStatus {
  final EventRepository repository;

  GetEventsByStatus(this.repository);

  Stream<List<Event>> call(EventStatus status) {
    return repository.getEventsStreamByStatus(status);
  }
}
