// lib/services/event_service.dart
import 'package:flutter/foundation.dart';
import '../models/event_model.dart';
import 'local_storage.dart';

class EventService {
  EventService._private();
  static final EventService instance = EventService._private();

  /// This ValueNotifier will hold the current list of events.
  final ValueNotifier<List<EventModel>> events =
      ValueNotifier<List<EventModel>>(<EventModel>[]);

  /// Initialize by loading from local storage
  Future<void> loadFromStorage() async {
    final raw = await LocalStorage.instance.loadAllEvents();
    final list = raw.map((s) => EventModel.fromJson(s)).toList();
    // Sort by date ascending
    list.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    events.value = list;
  }

  Future<void> addEvent(EventModel e) async {
    final current = List<EventModel>.from(events.value);
    current.add(e);
    current.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    events.value = current;
    await _persist();
  }

  Future<void> removeEvent(String id) async {
    final current = events.value.where((ev) => ev.id != id).toList();
    events.value = current;
    await _persist();
  }

  Future<void> _persist() async {
    final raw = events.value.map((e) => e.toJson()).toList();
    await LocalStorage.instance.saveRawList(raw);
  }
}
