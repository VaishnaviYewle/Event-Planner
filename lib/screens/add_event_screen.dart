// lib/screens/add_event_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../services/event_service.dart';
import '../services/notification_service.dart';

class AddEventScreen extends StatefulWidget {
  static const routeName = '/add-event';
  const AddEventScreen({Key? key}) : super(key: key);

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtl = TextEditingController();
  final _descCtl = TextEditingController();
  DateTime? _selectedDateTime;

  final EventService _eventService = EventService.instance;

  // Available reminder times
  final List<int> _reminderOptions = [5, 10, 30, 60, 1440]; // in minutes
  int _selectedReminder = 10; // default 10 minutes

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(const Duration(minutes: 30))),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate() || _selectedDateTime == null) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please pick date & time')),
        );
      }
      return;
    }

    final newEvent = EventModel(
      id: const Uuid().v4(),
      title: _titleCtl.text.trim(), 
      description: _descCtl.text.trim(),
      dateTime: _selectedDateTime!,
      reminderMinutes: _selectedReminder,
    );

    await _eventService.addEvent(newEvent);

    // Calculate reminder time
    final reminderTime =
        _selectedDateTime!.subtract(Duration(minutes: _selectedReminder));
    if (reminderTime.isAfter(DateTime.now())) {
      await NotificationService.instance.scheduleNotification(
        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique id
        title: 'Upcoming Event',
        body:
            '${newEvent.title} starts at ${DateFormat('hh:mm a').format(newEvent.dateTime)}',
        scheduledTime: reminderTime,
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final dateText = _selectedDateTime == null
        ? 'No date chosen'
        : DateFormat('EEE, d MMM y • hh:mm a').format(_selectedDateTime!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtl,
                decoration: const InputDecoration(labelText: 'Event Title'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Please enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtl,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 3,
                maxLines: 6,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Please enter description'
                    : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date & Time'),
                subtitle: Text(dateText),
                trailing: TextButton(
                  onPressed: _pickDateTime,
                  child: const Text('Pick'),
                ),
              ),
              const SizedBox(height: 16),

              // Reminder time dropdown
              DropdownButtonFormField<int>(
                value: _selectedReminder,
                items: _reminderOptions.map((minutes) {
                  String label;
                  if (minutes < 60) {
                    label = '$minutes minutes before';
                  } else if (minutes == 60) {
                    label = '1 hour before';
                  } else {
                    label = '${minutes ~/ 1440} day before';
                  }
                  return DropdownMenuItem<int>(
                    value: minutes,
                    child: Text(label),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedReminder = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Reminder Time',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveEvent,
                child: const Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
