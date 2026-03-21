import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/events/domain/usecases/get_cities_by_ids.dart';
import 'package:local_happens/features/events/domain/usecases/get_event_by_id.dart';
import 'package:local_happens/features/events/domain/usecases/get_users_by_ids.dart';
import 'package:local_happens/features/events/presentation/models/event_ui_model.dart';
import 'event_details_state.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final GetEventById getEventByIdUseCase;
  final GetUsersByIds getUsersByIdsUseCase;
  final GetCitiesByIds getCitiesByIdsUseCase;

  EventDetailsCubit({
    required this.getEventByIdUseCase,
    required this.getUsersByIdsUseCase,
    required this.getCitiesByIdsUseCase,
  }) : super(EventDetailsInitial());

  Future<void> loadEvent(String id) async {
    emit(EventDetailsLoading());

    try {
      final event = await getEventByIdUseCase(id);

      final cities = await getCitiesByIdsUseCase({event.cityId});
      final users = await getUsersByIdsUseCase({event.userId});
      
      final city = cities.first;
      final user = users.first;

      final uiModel = EventUiModel.fromEvent(
        event,
        city.name,
        user.name,
      );

      emit(EventDetailsLoaded(uiModel));
    } catch (e) {
      emit(EventDetailsError(e.toString()));
    }
  }
}
