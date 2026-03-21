import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/favorites/domain/usecases/add_favorite.dart';
import 'package:local_happens/features/favorites/domain/usecases/get_favorites.dart';
import 'package:local_happens/features/favorites/domain/usecases/is_favorite.dart';
import 'package:local_happens/features/favorites/domain/usecases/remove_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final GetFavorites getFavoritesUseCase;
  final AddFavorite addFavoriteUseCase;
  final RemoveFavorite removeFavoriteUseCase;
  final IsFavorite isFavoriteUseCase;

  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.removeFavoriteUseCase,
    required this.isFavoriteUseCase,
  }) : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await getFavoritesUseCase(NoParams());
      emit(
        FavoritesLoaded(
          favorites,
          favoriteIds: favorites.map((e) => e.id).toSet(),
        ),
      );
    } catch (e) {
      emit(
        FavoritesError(
          e.toString(),
          favorites: state.favorites,
          favoriteIds: state.favoriteIds,
        ),
      );
    }
  }

  // Future<void> addFavoriteEvent(String eventId) async {
  //   try {
  //     await addFavoriteUseCase(AddFavoriteParams(eventId: eventId));
  //     await loadFavorites();
  //   } catch (e) {
  //     emit(FavoritesError(e.toString()));
  //   }
  // }
  // Future<void> addFavoriteEvent(String eventId) async {
  //   try {
  //     final updatedIds = Set<String>.from(state.favoriteIds)..add(eventId);

  //     emit(FavoritesLoaded(state.favorites, favoriteIds: updatedIds));

  //     await addFavoriteUseCase(AddFavoriteParams(eventId: eventId));
  //   } catch (e) {
  //     emit(FavoritesError(e.toString()));
  //   }
  // }

  Future<void> addFavoriteEvent(String eventId) async {
    try {
      await addFavoriteUseCase(AddFavoriteParams(eventId: eventId));
      await loadFavorites();
    } catch (e) {
      emit(
        FavoritesError(
          e.toString(),
          favorites: state.favorites,
          favoriteIds: state.favoriteIds,
        ),
      );
    }
  }

  // Future<void> removeFavoriteEvent(String eventId) async {
  //   try {
  //     // локальне видалення
  //     final updatedFavorites = state.favorites
  //         .where((e) => e.id != eventId)
  //         .toList();
  //     final updatedIds = Set<String>.from(state.favoriteIds)..remove(eventId);

  //     emit(FavoritesLoaded(updatedFavorites, favoriteIds: updatedIds));

  //     // видалення на сервері
  //     await removeFavoriteUseCase(RemoveFavoriteParams(eventId: eventId));
  //   } catch (e) {
  //     emit(
  //       FavoritesError(
  //         e.toString(),
  //         favorites: state.favorites,
  //         favoriteIds: state.favoriteIds,
  //       ),
  //     );
  //   }
  // }

  Future<void> removeFavoriteEvent(String eventId) async {
    try {
      await removeFavoriteUseCase(RemoveFavoriteParams(eventId: eventId));
      await loadFavorites();
    } catch (e) {
      emit(
        FavoritesError(
          e.toString(),
          favorites: state.favorites,
          favoriteIds: state.favoriteIds,
        ),
      );
    }
  }

  Future<void> toggleFavorite(String eventId) async {
    final isFavorite = state.favoriteIds.contains(eventId);

    if (isFavorite) {
      await removeFavoriteEvent(eventId);
      return;
    }

    await addFavoriteEvent(eventId);
  }

  Future<bool> checkIsFavorite(String eventId) async {
    if (state.favoriteIds.contains(eventId)) return true;

    try {
      final isFavorite = await isFavoriteUseCase(
        IsFavoriteParams(eventId: eventId),
      );

      if (!isClosed && isFavorite) {
        final updatedIds = Set<String>.from(state.favoriteIds)..add(eventId);
        emit(FavoritesLoaded(state.favorites, favoriteIds: updatedIds));
      }

      return isFavorite;
    } catch (_) {
      return false;
    }
  }
}
