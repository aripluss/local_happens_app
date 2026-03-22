import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_state.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/presentation/widgets/event_status_badge.dart';
import 'package:local_happens/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:local_happens/features/profile/presentation/cubit/profile_state.dart';

class ProfileEventsWidget extends StatefulWidget {
  const ProfileEventsWidget({super.key});

  @override
  State<ProfileEventsWidget> createState() => _ProfileEventsWidgetState();
}

class _ProfileEventsWidgetState extends State<ProfileEventsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().subscribeUserEvents(
      (context.read<AuthCubit>().state as Authenticated).user.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Мої події',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: 16),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileEventsLoaded) {
              if (state.events.isEmpty) {
                return const Center(
                  child: Text('Ви ще не створили жодної події'),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return _EventCardWidget(event: event);
                },
              );
            } else {
              return const Center(child: Text('Помилка завантаження подій'));
            }
          },
        ),
      ],
    );
  }
}

class _EventCardWidget extends StatelessWidget {
  const _EventCardWidget({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: event.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          placeholder: (context, url) {
            return const Center(child: CircularProgressIndicator());
          },
          errorWidget: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            EventStatusBadge(status: event.status),
          ],
        ),
      ),
    );
  }
}
