import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';

class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final FavoriteRepository repository;

  AddFavorite(this.repository);

  @override
  Future<void> call(AddFavoriteParams params) {
    return repository.addFavorite(params.eventId);
  }
}

class AddFavoriteParams {
  final String eventId;

  AddFavoriteParams({required this.eventId});
}
