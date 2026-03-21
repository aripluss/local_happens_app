import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class DeleteEvent implements UseCase<void, Event> {
  final EventRepository repository;

  DeleteEvent(this.repository);

  @override
  Future<void> call(Event event) async {
    await repository.deleteEvent(event);
  }
}