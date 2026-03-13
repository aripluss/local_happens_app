import '../../../events/domain/entities/event.dart';

abstract class FavoriteRepository {
  Future<List<Event>> getFavorites();
  Future<void> addFavorite(String eventId);
  Future<void> removeFavorite(String eventId);
}
