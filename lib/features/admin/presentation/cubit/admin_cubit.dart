import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/admin/domain/usecases/change_event_status.dart';
import 'package:local_happens/features/admin/domain/usecases/get_events_by_status.dart';
import 'package:local_happens/features/admin/presentation/cubit/admin_state.dart';
import 'package:local_happens/features/auth/data/models/user_model.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';
import 'package:local_happens/features/events/domain/usecases/get_users_by_ids.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetEventsByStatus getEventsByStatus;
  final ChangeEventStatus changeEventStatusUseCase;
  final GetUsersByIds getUsersByIdsUseCase;

  StreamSubscription? _pendingSubscription;
  StreamSubscription? _approvedSubscription;
  StreamSubscription? _rejectedSubscription;

  // кеш
  final Map<String, UserModel> usersMap = {};

  AdminCubit({
    required this.getEventsByStatus,
    required this.changeEventStatusUseCase,
    required this.getUsersByIdsUseCase,
  }) : super(AdminInitial());

  //  події
  void loadEvents() {
    emit(AdminLoading());
    try {
      _pendingSubscription?.cancel();
      _approvedSubscription?.cancel();
      _rejectedSubscription?.cancel();

      _pendingSubscription = getEventsByStatus(EventStatus.pending).listen(
        (events) {
          _updateLoadedState(pendingEvents: events);
          loadUsersForEvents(events);
        },
        onError: (err) {
          emit(AdminError(err.toString()));
        },
      );

      _approvedSubscription = getEventsByStatus(EventStatus.approved).listen(
        (events) {
          _updateLoadedState(approvedEvents: events);
          loadUsersForEvents(events);
        },
        onError: (err) {
          emit(AdminError(err.toString()));
        },
      );

      _rejectedSubscription = getEventsByStatus(EventStatus.rejected).listen(
        (events) {
          _updateLoadedState(rejectedEvents: events);
          loadUsersForEvents(events);
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
    List<Event>? pendingEvents,
    List<Event>? approvedEvents,
    List<Event>? rejectedEvents,
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

  // організатори подій
  Future<void> loadUsersForEvents(List<Event> events) async {
    final idsToLoad = events
        .map((e) => e.userId)
        .where((id) => !usersMap.containsKey(id))
        .toSet();

    if (idsToLoad.isEmpty) return;

    try {
      final users = await getUsersByIdsUseCase(idsToLoad);
      for (var user in users) {
        usersMap[user.id] = user;
      }

      if (state is AdminLoaded) {
        emit((state as AdminLoaded).copyWith(usersMap: Map.from(usersMap)));
      }
    } catch (e) {
      print('Error loading users: $e');
    }
  }

  // (доступ до кешованого організатора)
  UserModel? getUser(String userId) => usersMap[userId];

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
