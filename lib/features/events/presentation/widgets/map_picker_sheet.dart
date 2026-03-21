import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPickerSheet extends StatefulWidget {
  const MapPickerSheet({super.key});

  @override
  State<MapPickerSheet> createState() => _MapPickerSheetState();
}

class _MapPickerSheetState extends State<MapPickerSheet> {
  LatLng? _selectedPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(50.4501, 30.5234),
              zoom: 12,
            ),
            markers: _selectedPosition != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: _selectedPosition!,
                    ),
                  }
                : {},
            onTap: (position) {
              setState(() => _selectedPosition = position);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedPosition != null
                  ? () => Navigator.of(context).pop(_selectedPosition)
                  : null,
              child: const Text('Підтвердити місце'),
            ),
          ),
        ),
      ],
    );
  }
}
