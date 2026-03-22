import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/admin/domain/usecases/change_event_status.dart';
import 'package:local_happens/features/admin/domain/usecases/get_events_by_status.dart';
import 'package:local_happens/features/admin/presentation/cubit/admin_state.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';
import 'package:local_happens/features/events/domain/usecases/get_cities_by_ids.dart';
import 'package:local_happens/features/events/domain/usecases/get_users_by_ids.dart';
import 'package:local_happens/features/events/presentation/models/event_ui_model.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetEventsByStatus getEventsByStatus;
  final ChangeEventStatus changeEventStatusUseCase;
  final GetUsersByIds getUsersByIdsUseCase;
  final GetCitiesByIds getCitiesByIdsUseCase;

  StreamSubscription? _pendingSubscription;
  StreamSubscription? _approvedSubscription;
  StreamSubscription? _rejectedSubscription;

  AdminCubit({
    required this.getEventsByStatus,
    required this.changeEventStatusUseCase,
    required this.getUsersByIdsUseCase,
    required this.getCitiesByIdsUseCase,
  }) : super(AdminInitial());

  //  події
  void loadEvents() {
    emit(AdminLoading());
    try {
      _pendingSubscription?.cancel();
      _approvedSubscription?.cancel();
      _rejectedSubscription?.cancel();

      _pendingSubscription = getEventsByStatus(EventStatus.pending).listen(
        (events) async {
          final mappedEvents = await _mapEvents(events);
          _updateLoadedState(pendingEvents: mappedEvents);
        },
        onError: (err) {
          emit(AdminError(err.toString()));
        },
      );

      _approvedSubscription = getEventsByStatus(EventStatus.approved).listen(
        (events) async {
          final mappedEvents = await _mapEvents(events);
          _updateLoadedState(approvedEvents: mappedEvents);
        },
        onError: (err) {
          emit(AdminError(err.toString()));
        },
      );

      _rejectedSubscription = getEventsByStatus(EventStatus.rejected).listen(
        (events) async {
          final mappedEvents = await _mapEvents(events);
          _updateLoadedState(rejectedEvents: mappedEvents);
        },
        onError: (err) {
          emit(AdminError(err.toString()));
        },
      );
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  void _updateLoadedState({
    List<EventUiModel>? pendingEvents,
    List<EventUiModel>? approvedEvents,
    List<EventUiModel>? rejectedEvents,
  }) {
    if (state is AdminLoaded) {
      final loadedState = state as AdminLoaded;
      emit(
        loadedState.copyWith(
          pendingEvents: pendingEvents,
          approvedEvents: approvedEvents,
          rejectedEvents: rejectedEvents,
        ),
      );
    } else {
      emit(
        AdminLoaded(
          pendingEvents: pendingEvents ?? [],
          approvedEvents: approvedEvents ?? [],
          rejectedEvents: rejectedEvents ?? [],
        ),
      );
    }
  }

  // мапінг подій в EventUiModel для відображення в UI
  Future<List<EventUiModel>> _mapEvents(List<Event> events) async {
    final usersIds = events.map((e) => e.userId).toSet();
    final citiesIds = events.map((e) => e.cityId).toSet();
    final users = await getUsersByIdsUseCase(usersIds);
    final cities = await getCitiesByIdsUseCase(citiesIds);
    return events.map((e) {
      final user = users.firstWhere((u) => u.id == e.userId);
      final city = cities.firstWhere((c) => c.id == e.cityId);
      return EventUiModel.fromEvent(e, city.name, user.name);
    }).toList();
  }

  // статуси
  Future<void> changeEventStatus(String id, EventStatus status) async {
    try {
      emit(AdminLoading());
      await changeEventStatusUseCase(id, status);
    } catch (e) {
      emit(AdminError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _pendingSubscription?.cancel();
    _approvedSubscription?.cancel();
    _rejectedSubscription?.cancel();
    return super.close();
  }
}
