import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';

class GetFavorites implements UseCase<List<Event>, NoParams> {
  final FavoriteRepository repository;

  GetFavorites(this.repository);

  @override
  Future<List<Event>> call(NoParams params) {
    return repository.getFavorites();
  }
}
