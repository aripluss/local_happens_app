import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';
import 'package:local_happens/features/events/presentation/cubit/events_cubit.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  double? selectedLat;
  double? selectedLng;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),

            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            ElevatedButton(
              onPressed: () {
                // выбор даты
              },
              child: const Text('Select date'),
            ),

            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(50.4501, 30.5234),
                  zoom: 12,
                ),
                markers: selectedLat != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: LatLng(selectedLat!, selectedLng!),
                        ),
                      }
                    : {},
                onTap: (LatLng position) {
                  setState(() {
                    selectedLat = position.latitude;
                    selectedLng = position.longitude;
                  });
                },
              ),
            ),

            ElevatedButton(
              onPressed: _createEvent,
              child: const Text('Create event'),
            ),
          ],
        ),
      ),
    );
  }

  void _createEvent() async {
    final eventsCubit = context.read<EventsCubit>();
    final navigator = GoRouter.of(context);

    final title = titleController.text;
    final description = descriptionController.text;
    final date = selectedDate;
    final lat = selectedLat;
    final lng = selectedLng;
    final user = await context.read<AuthCubit>().getUser();

    if (title.isEmpty ||
        description.isEmpty ||
        date == null ||
        lat == null ||
        lng == null ||
        user == null) {
      return;
    }

    final event = Event(
      id: '',
      title: title,
      description: description,
      category: 'music',
      city: 'Kyiv',
      date: date,
      locationName: 'Selected location',
      latitude: lat,
      longitude: lng,
      imageUrl: '',
      createdBy: user.id,
    );

    if (!mounted) {
      return;
    }
    eventsCubit.createEvent(event);
    navigator.pop();
  }
}
