import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/events/domain/usecases/delete_event.dart';
import 'package:local_happens/features/events/domain/usecases/filter_events.dart';
import 'package:local_happens/features/events/domain/usecases/get_event_by_id.dart';
import 'package:local_happens/features/events/domain/usecases/update_event.dart';
import 'package:local_happens/core/usecases/usecase.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/usecases/create_event.dart';
import 'package:local_happens/features/events/domain/usecases/get_events.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final GetEvents getEvents;
  final CreateEvent createEventUseCase;
  final UpdateEvent updateEventUseCase;
  final DeleteEvent deleteEventUseCase;
  final FilterEvents filterEventsUseCase;
  final GetEventById getEventByIdUseCase;

  EventsCubit({
    required this.getEvents,
    required this.createEventUseCase,
    required this.updateEventUseCase,
    required this.deleteEventUseCase,
    required this.filterEventsUseCase,
    required this.getEventByIdUseCase,
  }) : super(EventsInitial());

  Future<void> loadEvents() async {
    emit(EventsLoading());
    try {
      final events = await getEvents(NoParams());
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> filterEvents(String query) async {
    emit(EventsLoading());
    try {
      final events = await filterEventsUseCase(query);
      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> getEventById(String id) async {
    emit(EventsLoading());
    try {
      final event = await getEventByIdUseCase(id);
      emit(EventLoaded(event));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> createEvent(Event event) async {
    emit(EventsLoading());
    try {
      await createEventUseCase(event);
      await loadEvents();
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> updateEvent(Event event) async {
    emit(EventsLoading());
    try {
      await updateEventUseCase(event);
      await loadEvents();
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> deleteEvent(Event event) async {
    emit(EventsLoading());
    try {
      await deleteEventUseCase(event);
      await loadEvents();
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}
