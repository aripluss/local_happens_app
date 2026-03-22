import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';

class RemoveFavorite implements UseCase<void, RemoveFavoriteParams> {
  final FavoriteRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<void> call(RemoveFavoriteParams params) {
    return repository.removeFavorite(params.eventId);
  }
}

class RemoveFavoriteParams {
  final String eventId;

  RemoveFavoriteParams({required this.eventId});
}
