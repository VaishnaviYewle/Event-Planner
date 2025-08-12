// lib/widgets/event_card.dart
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const EventCard({
    Key? key,
    required this.event,
    this.onTap,
    this.onDelete,
  }) : super(key: key);

  String get _formattedDate {
    final fmt = DateFormat('EEE, d MMM y • hh:mm a');
    return fmt.format(event.dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        onTap: onTap,
        title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(_formattedDate, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 6),
            Text(
              event.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
