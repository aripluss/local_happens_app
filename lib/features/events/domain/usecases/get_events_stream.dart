import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetEventsStream {
  final EventRepository repository;

  GetEventsStream(this.repository);
  Stream<List<Event>> call() {
    return repository.getEventsStream();
  }
}
