import 'package:flutter/material.dart';
import 'app.dart';
import 'package:json_theme_plus/json_theme_plus.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'dart:convert'; // For jsonDecode
import 'services/profile_service.dart'; // Import ProfileService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the theme configuration from ProfileService
  final profileService = ProfileService();
  final config = await profileService.loadConfig();
  String themeName = config['theme'] ?? 'light'; // Get the theme name from config

  ThemeData theme;

  // Load the appropriate theme based on the configuration
  switch (themeName) {
    case 'light':
      theme = ThemeData.light();
      break;
    case 'dark':
      theme = ThemeData.dark();
      break;
    case 'sepia':
      final themeStr = await rootBundle.loadString('assets/sepia.json');
      final themeJson = jsonDecode(themeStr);
      theme = ThemeDecoder.decodeThemeData(themeJson)!; // Decode the sepia theme
      break;
    default:
      theme = ThemeData.light();
  }

  runApp(MyApp(theme: theme));
}
