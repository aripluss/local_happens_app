import '../../../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class CreateEvent implements UseCase<Event, Event> {
  final EventRepository repository;

  CreateEvent(this.repository);

  @override
  Future<Event> call(Event event) async {
    return await repository.createEvent(event);
  }
}