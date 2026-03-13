import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_favorite.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final AddFavorite addFavoriteUseCase;

  FavoritesCubit({
    required this.addFavoriteUseCase,
  }) : super(FavoritesInitial());

  Future<void> addFavorite(String eventId) async {
    emit(FavoritesLoading());
    try {
      await addFavoriteUseCase(AddFavoriteParams(eventId: eventId));
      emit(const FavoritesLoaded([]));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }
}
