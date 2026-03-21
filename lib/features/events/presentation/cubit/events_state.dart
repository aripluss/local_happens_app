import 'package:equatable/equatable.dart';
import 'package:local_happens/features/events/presentation/models/event_ui_model.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {}

class EventsLoading extends EventsState {}

class EventsLoaded extends EventsState {
  final List<EventUiModel> events;

  const EventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}


class EventsError extends EventsState {
  final String message;

  const EventsError(this.message);

  @override
  List<Object?> get props => [message];
}
