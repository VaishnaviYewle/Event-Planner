// lib/models/event_model.dart
import 'dart:convert';

class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final int reminderMinutes; // NEW

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.reminderMinutes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'reminderMinutes': reminderMinutes,
    };
  }

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      reminderMinutes: map['reminderMinutes'] ?? 10,
    );
  }

  String toJson() => json.encode(toMap());

  factory EventModel.fromJson(String source) =>
      EventModel.fromMap(json.decode(source));
}
