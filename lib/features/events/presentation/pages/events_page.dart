import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_state.dart';
import 'package:local_happens/features/events/presentation/cubit/events_cubit.dart';
import 'package:local_happens/features/events/presentation/cubit/events_state.dart';
import 'package:local_happens/features/events/presentation/widgets/event_card_widget.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventsLoaded && state.events.isNotEmpty) {
            return ListView.builder(  
              itemCount: state.events.length,
              itemBuilder: (context, index) {
                final event = state.events[index];
                return EventCard(event: event);
              },
            );
          } else if (state is EventsError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No events found'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (context.read<AuthCubit>().state is! AuthAuthenticated) {
            context.push('/login');
            return;
          }
          context.push('/events/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

