import '../../domain/repositories/favorite_repository.dart';
import '../../../events/domain/entities/event.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  @override
  Future<List<Event>> getFavorites() async {
    return [];
  }

  @override
  Future<void> addFavorite(String eventId) async {
    // Shared prefs or local db logic placeholder
  }

  @override
  Future<void> removeFavorite(String eventId) async {
    // Shared prefs or local db logic placeholder
  }
}
