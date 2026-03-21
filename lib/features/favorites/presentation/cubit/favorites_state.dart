import 'package:equatable/equatable.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';

abstract class FavoritesState extends Equatable {
  final List<Event> favorites;
  final Set<String> favoriteIds;

  const FavoritesState({
    this.favorites = const [],
    this.favoriteIds = const {},
  });

  @override
  List<Object> get props => [favorites, favoriteIds];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading({super.favorites, super.favoriteIds});
}

class FavoritesLoaded extends FavoritesState {
  const FavoritesLoaded(List<Event> favorites, {Set<String>? favoriteIds})
    : super(favorites: favorites, favoriteIds: favoriteIds ?? const {});
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message, {super.favorites, super.favoriteIds});

  @override
  List<Object> get props => [message, favorites, favoriteIds];
}
