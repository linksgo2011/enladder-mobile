import 'package:flutter/material.dart';
import '../../services/book_service.dart'; // 导入 BookService
import '../profile/about_screen.dart'; // 导入关于页面

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BookService _bookService = BookService(); // 创建 BookService 实例

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
              title: const Text('通用'),
              onTap: () {
                // 导航到设置页面或显示提示
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('设置功能尚未开发')),
                );
              },
            ),
            ListTile(
              title: const Text('清理书架'),
              onTap: () async {
                // 清理书架
                await _bookService.clearBookshelf();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('书架已清理')),
                );
              },
            ),
            ListTile(
              title: const Text('关于'),
              onTap: () {
                // 导航到关于页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
