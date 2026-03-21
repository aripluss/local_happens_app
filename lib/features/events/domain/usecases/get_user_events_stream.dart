import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class GetUserEventsStream {
  final EventRepository repository;

  GetUserEventsStream(this.repository);

  Stream<List<Event>> call(String userId) {
    return repository.getUserEventsStream(userId);
  }
}
