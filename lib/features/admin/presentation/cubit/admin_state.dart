import 'package:equatable/equatable.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';

abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<Event> pendingEvents;
  final List<Event> approvedEvents;
  final List<Event> rejectedEvents;

  const AdminLoaded({
    required this.pendingEvents,
    required this.approvedEvents,
    required this.rejectedEvents,
  });

  @override
  List<Object?> get props => [pendingEvents, approvedEvents, rejectedEvents];

  AdminLoaded copyWith({
    List<Event>? pendingEvents,
    List<Event>? approvedEvents,
    List<Event>? rejectedEvents,
  }) {
    return AdminLoaded(
      pendingEvents: pendingEvents ?? this.pendingEvents,
      approvedEvents: approvedEvents ?? this.approvedEvents,
      rejectedEvents: rejectedEvents ?? this.rejectedEvents,
    );
  }
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}
