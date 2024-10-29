import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For SystemNavigator
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
    // Show confirmation dialog before saving
    final shouldRestart = await _showRestartDialog();
    if (shouldRestart) {
      await _profileService.saveConfig(_config);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存，请重启应用以应用更改')),
      );
      // Restart the app
      SystemNavigator.pop(); // Close the app
    }
  }

  Future<bool> _showRestartDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('重启应用'),
          content: const Text('为了更好的体验，请重启应用。您确定要保存设置并重启吗？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // Return false
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Return true
              child: const Text('确定'),
            ),
          ],
        );
      },
    ).then((value) => value ?? false); // Return false if null
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
            const SizedBox(height: 20), // Increased space above the dropdowns
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
            const SizedBox(height: 16), // Space between dropdowns
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
            const SizedBox(height: 20), // Space before the button
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
