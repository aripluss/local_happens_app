import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_happens/core/constants/app_text_styles.dart';
import 'package:local_happens/features/events/presentation/cubit/events_cubit.dart';
import 'package:local_happens/features/events/presentation/cubit/events_state.dart';

class EventsMapPage extends StatelessWidget {
  const EventsMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Події на мапі', style: AppTextStyles.headline),
      ),
      body: BlocBuilder<EventsCubit, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EventsLoaded) {
            final markers = state.events.map((eventUiModel) {
              return Marker(
                markerId: MarkerId(eventUiModel.event.id),
                position: LatLng(
                  eventUiModel.event.latitude,
                  eventUiModel.event.longitude,
                ),
                infoWindow: InfoWindow(
                  title: eventUiModel.event.title,
                  snippet: eventUiModel.event.locationAddress,
                  onTap: () {
                    context.push('/events/${eventUiModel.event.id}');
                  },
                ),
              );
            }).toSet();

            return GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(50.4501, 30.5234),
                zoom: 12,
              ),
              markers: markers,
            );
          }

          return const Center(child: Text('No events'));
        },
      ),
    );
  }
}
