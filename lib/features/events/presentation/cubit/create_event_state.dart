import 'package:equatable/equatable.dart';
import 'package:local_happens/features/events/domain/entities/location_info.dart';

abstract class CreateEventState extends Equatable {
  const CreateEventState();

  @override
  List<Object?> get props => [];
}

class CreateEventInitial extends CreateEventState {}

class CreateEventLocationLoading extends CreateEventState {}

class CreateEventLocationResolved extends CreateEventState {
  final LocationInfo location;

  const CreateEventLocationResolved(this.location);

  @override
  List<Object?> get props => [location];
}

class CreateEventSubmitting extends CreateEventState {}

class CreateEventSuccess extends CreateEventState {}

class CreateEventError extends CreateEventState {
  final String message;

  const CreateEventError(this.message);

  @override
  List<Object?> get props => [message];
}
