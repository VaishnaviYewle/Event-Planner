// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../services/event_service.dart';
import '../widgets/event_card.dart';
import 'add_event_screen.dart';
import 'event_detail_screen.dart';
import '../models/event_model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final EventService _service = EventService.instance;

  @override
  void initState() {
    super.initState();
    _service.loadFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Planner'),
      ),
      body: ValueListenableBuilder<List<EventModel>>(
        valueListenable: _service.events,
        builder: (context, events, _) {
          if (events.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No upcoming events', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, AddEventScreen.routeName),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Event'),
                  ),
                ],
              ),
            );
          }

          // show list
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, idx) {
              final e = events[idx];
              return EventCard(
                event: e,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventDetailScreen(event: e),
                    ),
                  );
                },
                onDelete: () async {
                  await _service.removeEvent(e.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event deleted')));
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddEventScreen.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }
}
