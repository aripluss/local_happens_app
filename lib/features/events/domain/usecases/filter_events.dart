import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/repositories/event_repository.dart';

class FilterEvents implements UseCase<List<Event>, String> {
  final EventRepository repository;

  FilterEvents(this.repository);

  @override
  Future<List<Event>> call(String query) async {
    return await repository.filterEvents(query);
  }
}