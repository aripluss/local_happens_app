import 'package:local_happens/features/events/domain/entities/event.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileEventsLoaded extends ProfileState {
  final List<Event> events;

  ProfileEventsLoaded(this.events);
}

class ProfileError extends ProfileState {
  final String error;

  ProfileError(this.error);
}