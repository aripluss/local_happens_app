import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/favorites/domain/repositories/favorite_repository.dart';

class IsFavorite implements UseCase<bool, IsFavoriteParams> {
  final FavoriteRepository repository;

  IsFavorite(this.repository);

  @override
  Future<bool> call(IsFavoriteParams params) async {
    return await repository.isFavorite(params.eventId);
  }
}

class IsFavoriteParams {
  final String eventId;

  IsFavoriteParams({required this.eventId});
}
