import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(event.title),
      subtitle: Text(event.description),
      onTap: () {
        context.push('/events/${event.id}');
      },
    );
  }
}
