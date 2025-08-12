import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._privateConstructor();
  static final LocalStorage instance = LocalStorage._privateConstructor();

  static const String _eventsKey = 'events_json_list';

  /// Private helper to fetch the raw event list from SharedPreferences
  Future<List<String>> _getRawList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_eventsKey) ?? <String>[];
  }

  /// Public method to load all events
  Future<List<String>> loadAllEvents() async {
    return await _getRawList();
  }

  /// Save entire events list as raw JSON strings
  Future<void> saveRawList(List<String> rawJsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_eventsKey, rawJsonList);
  }

  /// Clear all stored events
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_eventsKey);
  }

  /// Add one event JSON to the list
  Future<void> addRawItem(String json) async {
    final list = await _getRawList();
    list.add(json);
    await saveRawList(list);
  }
}
