import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class UpdateEvent implements UseCase<Event, Event> {
  final EventRepository repository;

  UpdateEvent(this.repository);

  @override
  Future<Event> call(Event event) async {
    return await repository.updateEvent(event);
  }
}
  