// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/add_event_screen.dart';
import 'screens/home_screen.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case AddEventScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AddEventScreen());
    default:
      return null;
  }
}
