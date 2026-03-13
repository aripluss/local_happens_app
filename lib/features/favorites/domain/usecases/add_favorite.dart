import '../../../../core/usecases/usecase.dart';
import '../repositories/favorite_repository.dart';

class AddFavorite implements UseCase<void, AddFavoriteParams> {
  final FavoriteRepository repository;

  AddFavorite(this.repository);

  @override
  Future<void> call(AddFavoriteParams params) async {
    return await repository.addFavorite(params.eventId);
  }
}

class AddFavoriteParams {
  final String eventId;

  AddFavoriteParams({required this.eventId});
}
