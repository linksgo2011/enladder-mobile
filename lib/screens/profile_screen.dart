import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首选项'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            ListTile(
              title: const Text('设置'),
              onTap: () {
                // 导航到设置页面或显示提示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('设置功能尚未开发')),
                );
              },
            ),
            ListTile(
              title: const Text('关于'),
              onTap: () {
                // 导航到关于页面或显示提示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('关于功能尚未开发')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
