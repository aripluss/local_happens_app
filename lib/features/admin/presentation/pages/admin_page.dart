import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_happens/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:local_happens/features/admin/presentation/cubit/admin_state.dart';
import 'package:local_happens/features/admin/presentation/widgets/admin_event_card.dart';
import 'package:local_happens/features/events/domain/entities/event.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.shield_outlined, size: 28),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Модерація',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Управління подіями',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'На модерації'),
              Tab(text: 'Схвалені'),
              Tab(text: 'Відхилені'),
            ],
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            if (state is AdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AdminError) {
              return Center(child: Text('Помилка: ${state.message}'));
            } else if (state is AdminLoaded) {
              return TabBarView(
                children: [
                  _buildEventList(state.pendingEvents),
                  _buildEventList(state.approvedEvents),
                  _buildEventList(state.rejectedEvents),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEventList(List<Event> events) {
    if (events.isEmpty) {
      return const Center(
        child: Text('Немає подій'),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return AdminEventCard(event: events[index]);
      },
    );
  }
}