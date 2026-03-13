import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class GetEventById implements UseCase<Event, String> {
  final EventRepository repository;

  GetEventById(this.repository);

  @override
  Future<Event> call(String id) async {
    return await repository.getEventById(id);
  }
}