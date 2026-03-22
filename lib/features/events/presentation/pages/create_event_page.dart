import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:local_happens/features/auth/presentation/cubit/auth_state.dart';
import 'package:local_happens/features/events/presentation/cubit/create_event_cubit.dart';
import 'package:local_happens/features/events/presentation/cubit/create_event_state.dart';
import 'package:local_happens/features/events/presentation/widgets/map_picker_sheet.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _linkController = TextEditingController();
  final _cityController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  XFile? _selectedImage;

  double? _lat;
  double? _lng;
  String? _resolvedCityName;

  static const List<String> _categories = [
    'Музика',
    'Спорт',
    'Їжа',
    'Мистецтво',
    'Технології',
    'Освіта',
    'Розваги',
    'Бізнес',
    'Інше',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _linkController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Нова подія')),
      body: BlocConsumer<CreateEventCubit, CreateEventState>(
        listener: (context, state) {
          if (state is CreateEventLocationResolved) {
            _lat = state.location.lat;
            _lng = state.location.lng;
            _resolvedCityName = state.location.cityName;
            _cityController.text = state.location.cityName;
            _addressController.text = state.location.address;
          }
          if (state is CreateEventSuccess) {
            context.pop();
          }
          if (state is CreateEventError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading =
              state is CreateEventLocationLoading ||
              state is CreateEventSubmitting;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Photo ──────────────────────────────────────────────
                  const Text(
                    'Фото події',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CustomPaint(
                      painter: _DashedBorderPainter(
                        color: Colors.grey[400]!,
                        strokeWidth: 1,
                        dashWidth: 5,
                        dashSpace: 3,
                        borderRadius: 16,
                      ),
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: _selectedImage != null
                              ? Image.file(
                                  File(_selectedImage!.path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_outlined,
                                      size: 48,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Натисніть, щоб завантажити',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Title ──────────────────────────────────────────────
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Назва події *',
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Обов\'язкове поле'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Description ────────────────────────────────────────
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Опис *'),
                    maxLines: 4,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Обов\'язкове поле'
                        : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Category ───────────────────────────────────────────
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(labelText: 'Категорія *'),
                    items: _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                    validator: (v) => v == null ? 'Оберіть категорію' : null,
                  ),
                  const SizedBox(height: 12),

                  // ── Date ───────────────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _selectedDate == null
                          ? 'Оберіть дату *'
                          : 'Дата: ${_formatDate(_selectedDate!)}',
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDate,
                  ),

                  // ── Time ───────────────────────────────────────────────
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      _selectedTime == null
                          ? 'Оберіть час *'
                          : 'Час: ${_selectedTime!.format(context)}',
                    ),
                    trailing: const Icon(Icons.access_time),
                    onTap: _pickTime,
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  // ── Map picker button ──────────────────────────────────
                  ElevatedButton.icon(
                    onPressed: isLoading ? null : _openMapPicker,
                    icon: const Icon(Icons.map_outlined),
                    label: const Text('Вибрати місце на мапі'),
                  ),

                  // ── Location loading indicator ─────────────────────────
                  if (state is CreateEventLocationLoading) ...[
                    const SizedBox(height: 12),
                    const Row(
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Визначення адреси…'),
                      ],
                    ),
                  ],

                  // ── Auto-filled location fields ────────────────────────
                  if (_lat != null) ...[
                    const SizedBox(height: 12),

                    // City — read-only
                    TextFormField(
                      controller: _cityController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Місто *',
                        filled: true,
                        fillColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.4),
                        suffixIcon: const Tooltip(
                          message: 'Заповнено автоматично',
                          child: Icon(Icons.lock_outline, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Address — editable
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Адреса / Місце *',
                        helperText:
                            'Заповнено автоматично. Ви можете відредагувати.',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Обов\'язкове поле'
                          : null,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Link (optional) ────────────────────────────────────
                  TextFormField(
                    controller: _linkController,
                    decoration: const InputDecoration(
                      labelText: 'Посилання на подію',
                      hintText: 'https://…',
                    ),
                    keyboardType: TextInputType.url,
                  ),

                  const SizedBox(height: 24),

                  // ── Submit ─────────────────────────────────────────────
                  ElevatedButton.icon(
                    onPressed: (isLoading || state is CreateEventSubmitting)
                        ? null
                        : _submit,
                    icon: state is CreateEventSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_outlined),
                    label: const Text('Надіслати на модерацію'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _openMapPicker() async {
    final picked = await showModalBottomSheet<LatLng>(
      context: context,
      builder: (_) => const MapPickerSheet(),
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: false,
      isScrollControlled: true,
    );

    if (picked != null && mounted) {
      context.read<CreateEventCubit>().resolveLocationFromCoords(
        picked.latitude,
        picked.longitude,
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Будь ласка, оберіть дату')));
      return;
    }

    if (_lat == null || _lng == null || _resolvedCityName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Будь ласка, оберіть місце на мапі')),
      );
      return;
    }

    final date = _selectedDate!;
    final time = _selectedTime;
    final eventDate = time != null
        ? DateTime(date.year, date.month, date.day, time.hour, time.minute)
        : date;

    context.read<CreateEventCubit>().submitEvent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      date: eventDate,
      lat: _lat!,
      lng: _lng!,
      address: _addressController.text.trim(),
      cityName: _resolvedCityName!,
      link: _linkController.text.trim(),
      userId: (context.read<AuthCubit>().state as Authenticated).user.id,
      imageFilePath: _selectedImage?.path,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
