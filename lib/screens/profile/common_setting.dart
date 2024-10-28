import 'package:flutter/material.dart';
import '../../services/profile_service.dart';
import '../../models/settings.dart'; // Import the settings model

class CommonSetting extends StatefulWidget {
  const CommonSetting({Key? key}) : super(key: key);

  @override
  _CommonSettingState createState() => _CommonSettingState();
}

class _CommonSettingState extends State<CommonSetting> {
  final ProfileService _profileService = ProfileService();
  Map<String, dynamic> _config = {
    'theme': ThemeOption.light.name,
    'fontSize': FontSizeOption.medium.name
  };

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _profileService.loadConfig();
    setState(() {
      _config = config;
    });
  }

  Future<void> _saveConfig() async {
    await _profileService.saveConfig(_config);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('设置已保存')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通用设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
          children: [
            // Header for Reader Settings
            const Text(
              '阅读器设置',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16), // Add some space below the header
            DropdownButtonFormField<ThemeOption>(
              value: ThemeOption.values.firstWhere((e) => e.name == _config['theme']),
              decoration: const InputDecoration(labelText: '主题'),
              items: ThemeOption.values.map((ThemeOption theme) {
                return DropdownMenuItem<ThemeOption>(
                  value: theme,
                  child: Text(theme.label), // Use the label for display
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _config['theme'] = value?.name;
                });
              },
            ),
            DropdownButtonFormField<FontSizeOption>(
              value: FontSizeOption.values.firstWhere((e) => e.name == _config['fontSize']),
              decoration: const InputDecoration(labelText: '字体大小'),
              items: FontSizeOption.values.map((FontSizeOption size) {
                return DropdownMenuItem<FontSizeOption>(
                  value: size,
                  child: Text(size.label), // Use the label for display
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _config['fontSize'] = value?.name;
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveConfig,
              child: const Text('保存设置'),
            ),
          ],
        ),
      ),
    );
  }
}
