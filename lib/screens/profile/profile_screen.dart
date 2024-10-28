import 'package:enladder_mobile/screens/profile/common_setting.dart';
import 'package:flutter/material.dart';
import '../../services/book_service.dart'; // 导入 BookService
import '../profile/about_screen.dart';
import '../spikes/epub_test_screen.dart'; // 导入关于页面

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
                // 导航到通用设置页面
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CommonSetting()),
                );
              },
            ),
            ListTile(
              title: const Text('清理书架'),
              onTap: () {
                _confirmAndClearBookshelf(context, _bookService);
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
            //             ListTile(
            //   title: const Text('实验'),
            //   onTap: () {
            //     // 导航到关于页面
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const EpubTestScreen()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void _confirmAndClearBookshelf(BuildContext context, BookService bookService) async {
    // Show confirmation dialog
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('确认清理书架'),
          content: const Text('您确定要清理书架吗？此操作无法撤销。'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed No
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Yes
              },
              child: const Text('确认'),
            ),
          ],
        );
      },
    );

    // If the user confirmed, clear the bookshelf
    if (shouldClear == true) {
      await bookService.clearBookshelf();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('书架已清理')),
      );
    }
  }
}
