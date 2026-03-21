import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/events/domain/usecases/get_user_events_stream.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserEventsStream getUserEventsUseCase;

  StreamSubscription? _subscription;

  ProfileCubit(this.getUserEventsUseCase) : super(ProfileInitial());

  void subscribeUserEvents(String userId) {
    emit(ProfileLoading());

    _subscription?.cancel();

    _subscription = getUserEventsUseCase(userId).listen((events) {
      emit(ProfileEventsLoaded(events));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
