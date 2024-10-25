import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '应用名称: 电子书阅读器',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '版本: 0.1.0',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              '开发者: shaogefenhao.com',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              '描述: 英语梯子致力于通过辅助的方式提高英语使用的能力和体验，在使用中学习英语和积累单词。',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              '报告问题: https://enladder.com',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}