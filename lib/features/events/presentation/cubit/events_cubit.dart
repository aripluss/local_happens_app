import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/events/domain/usecases/delete_event.dart';
import 'package:local_happens/features/events/domain/usecases/filter_events.dart';
import 'package:local_happens/features/events/domain/usecases/get_cities_by_ids.dart';
import 'package:local_happens/features/events/domain/usecases/get_users_by_ids.dart';
import 'package:local_happens/features/events/domain/usecases/update_event.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/usecases/create_event.dart';
import 'package:local_happens/features/events/domain/usecases/get_events_stream.dart';
import 'package:local_happens/features/events/presentation/models/event_ui_model.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  final GetEventsStream getEvents;
  final CreateEvent createEventUseCase;
  final UpdateEvent updateEventUseCase;
  final DeleteEvent deleteEventUseCase;
  final FilterEvents filterEventsUseCase;
  final GetUsersByIds getUsersByIdsUseCase;
  final GetCitiesByIds getCitiesByIdsUseCase;

  StreamSubscription? _subscription;

  EventsCubit({
    required this.getEvents,
    required this.createEventUseCase,
    required this.updateEventUseCase,
    required this.deleteEventUseCase,
    required this.filterEventsUseCase,
    required this.getUsersByIdsUseCase,
    required this.getCitiesByIdsUseCase,
  }) : super(EventsInitial());

  void subscribeEvents() {
    emit(EventsLoading());
    _subscription?.cancel();
    _subscription = getEvents().listen((events) async {
      if (events.isEmpty) {
        emit(EventsLoaded([]));
        return;
      }
      final citiesIds = events.map((event) => event.cityId).toSet();
      final usersIds = events.map((event) => event.userId).toSet();
      
      final cities = await getCitiesByIdsUseCase(citiesIds);
      final users = await getUsersByIdsUseCase(usersIds);
      final eventsUiModel = events.map((event) {
        return EventUiModel.fromEvent(
          event,
          cities.firstWhere((city) => city.id == event.cityId).name,
          users.firstWhere((user) => user.id == event.userId).name,
        );
      }).toList();
      emit(EventsLoaded(eventsUiModel));
    }, onError: (error) => emit(EventsError(error.toString())));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> filterEvents(String query) async {
    emit(EventsLoading());
    try {
      final events = await filterEventsUseCase(query);
      final citiesIds = events.map((event) => event.cityId).toSet();
      final usersIds = events.map((event) => event.userId).toSet();

      final cities = await getCitiesByIdsUseCase(citiesIds);
      final users = await getUsersByIdsUseCase(usersIds);
      final eventsUiModel = events.map((event) {
        return EventUiModel.fromEvent(
          event,
          cities.firstWhere((city) => city.id == event.cityId).name,
          users.firstWhere((user) => user.id == event.userId).name,
        );
      }).toList();
      emit(EventsLoaded(eventsUiModel));
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }


  Future<void> createEvent(Event event) async {
    try {
      await createEventUseCase(event);
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> updateEvent(Event event) async {
    try {
      await updateEventUseCase(event);
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      await deleteEventUseCase(event);
    } catch (e) {
      emit(EventsError(e.toString()));
    }
  }
}
