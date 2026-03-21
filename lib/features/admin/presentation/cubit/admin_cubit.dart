import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/admin/domain/usecases/change_event_status.dart';
import 'package:local_happens/features/admin/domain/usecases/get_events_by_status.dart';
import 'package:local_happens/features/admin/presentation/cubit/admin_state.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/domain/entities/event_status.dart';

class AdminCubit extends Cubit<AdminState> {
  final GetEventsByStatus getEventsByStatus;
  final ChangeEventStatus changeEventStatusUseCase;

  StreamSubscription? _pendingSubscription;
  StreamSubscription? _approvedSubscription;
  StreamSubscription? _rejectedSubscription;

  AdminCubit({
    required this.getEventsByStatus,
    required this.changeEventStatusUseCase,
  }) : super(AdminInitial());

  void loadEvents() {
    emit(AdminLoading());
    try {
      _pendingSubscription?.cancel();
      _approvedSubscription?.cancel();
      _rejectedSubscription?.cancel();

      _pendingSubscription =
          getEventsByStatus(EventStatus.pending).listen((events) {
            _updateLoadedState(pendingEvents: events);
          }, onError: (err) {
            emit(AdminError(err.toString()));
          });

      _approvedSubscription =
          getEventsByStatus(EventStatus.approved).listen((events) {
            _updateLoadedState(approvedEvents: events);
          }, onError: (err) {
            emit(AdminError(err.toString()));
          });

      _rejectedSubscription =
          getEventsByStatus(EventStatus.rejected).listen((events) {
            _updateLoadedState(rejectedEvents: events);
          }, onError: (err) {
            emit(AdminError(err.toString()));
          });
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
      emit(loadedState.copyWith(
        pendingEvents: pendingEvents,
        approvedEvents: approvedEvents,
        rejectedEvents: rejectedEvents,
      ));
    } else {
      emit(AdminLoaded(
        pendingEvents: pendingEvents ?? [],
        approvedEvents: approvedEvents ?? [],
        rejectedEvents: rejectedEvents ?? [],
      ));
    }
  }

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
