import 'package:local_happens/features/events/domain/entities/event_status.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class ChangeEventStatus {
  final EventRepository repository;

  ChangeEventStatus(this.repository);

  Future<void> call(String id, EventStatus status) {
    return repository.updateEventStatus(id, status);
  }
}
