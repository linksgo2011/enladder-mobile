import 'package:flutter/material.dart';
import 'flash_words/flash_words_screen.dart'; // Import the FlashWords screen

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildExploreButton(context, '闪记单词', FlashWordsScreen()),
            const SizedBox(height: 20),
            _buildExploreButton(context, '短文阅读', null), // Replace with actual screen
            const SizedBox(height: 20),
            _buildExploreButton(context, '图背单词', null), // Replace with actual screen
            const SizedBox(height: 20),
            _buildExploreButton(context, '网页阅读', null), // Replace with actual screen
            const SizedBox(height: 20),
            _buildExploreButton(context, '定制电子书', null), // Replace with actual screen
          ],
        ),
      ),
    );
  }

  Widget _buildExploreButton(BuildContext context, String title, Widget? targetScreen) {
    return SizedBox(
      width: double.infinity, // 设置宽度为充满整个宽度
      child: ElevatedButton(
        onPressed: () {
          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title 功能尚未开发')),
            );
          }
        },
        child: Text(title),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}