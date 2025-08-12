# Event-Planner
Interview Task in Nexcore Alliance 

# 📅 Event Planner – Flutter Mobile Application

## 📌 Overview
The **Event Planner App** is a Flutter-based mobile application that allows users to **create, view, and manage events** with custom reminders.  
Users can:
- Add events with title, description, date & time.
- Set a **custom reminder time** (5 min, 10 min, 30 min, 1 hour, 1 day before).
- View all upcoming events.
- Get **local notifications** before the event.
- Persist events locally so they survive app restarts.
- Delete events anytime.

---

## ✨ Features
- **📄 Create Events** – Add title, description, and event date/time.
- **⏰ Custom Reminders** – Choose how many minutes/hours/days before the event to get notified.
- **🔔 Local Notifications** – Works offline, notifications shown even if app is closed.
- **💾 Persistent Storage** – Events stored locally using `SharedPreferences`.
- **🗑 Delete Events** – Remove events from the list and storage.
- **📱 Offline Support** – No internet connection required for core features.

---

## 📂 Project Structure






---

## 🛠 Tech Stack
- **Framework**: Flutter
- **Language**: Dart
- **Local Storage**: SharedPreferences
- **Notifications**: flutter_local_notifications + timezone
- **State Management**: Built-in (`ValueNotifier` + `ValueListenableBuilder`)
- **Date Formatting**: intl
- **Unique IDs**: uuid

---

## 📦 Dependencies
Add these to your `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.1.0
  intl: ^0.18.0
  uuid: ^3.0.7
  flutter_local_notifications: ^17.1.2
  timezone: ^0.9.2
```


To run :-

1. flutter clean
2. flutter pub get
3. flutter run
