import '../../../../core/usecases/usecase.dart';
import '../entities/event.dart';
import '../repositories/event_repository.dart';

class GetEvents implements UseCase<List<Event>, void> {
  final EventRepository repository;

  GetEvents(this.repository);

  @override
  Future<List<Event>> call([void params]) async {
    return await repository.getEvents();
  }
}
