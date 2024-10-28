import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/settings.dart'; // Import the settings model

class ProfileService {
  static const String _configFileName = 'user_config.json';

  Future<Map<String, dynamic>> loadConfig() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$_configFileName';
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } else {
      // Return default configuration if the file does not exist
      return _getDefaultConfig();
    }
  }

  Future<void> saveConfig(Map<String, dynamic> config) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$_configFileName';
    final file = File(filePath);
    await file.writeAsString(jsonEncode(config));
  }

  Map<String, dynamic> _getDefaultConfig() {
    return {
      'theme': ThemeOption.light.name,
      'fontSize': FontSizeOption.medium.name
    };
  }

  String getFontSizePercentage(String fontSize) {
    final fontSizeOption = FontSizeOption.values.firstWhere(
      (e) => e.name == fontSize,
      orElse: () => FontSizeOption.medium, // Default to medium if not found
    );
    return fontSizeOption.value; // Return the percentage value
  }

  Future<Map<String, dynamic>> getAllConfigurations() async {
    final config = await loadConfig();
    return {
      'theme': config['theme'],
      'fontSize': getFontSizePercentage(config['fontSize'])
    };
  }
}