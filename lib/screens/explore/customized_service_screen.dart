import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomizedServiceScreen extends StatelessWidget {
  const CustomizedServiceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('定制服务'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '定制服务',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              '学习英语最好的方法是使用英语，例如阅读自己喜欢的内容。Enladder App 提供免费的阅读服务，但由于定制需求多种多样，作者提供电子书代找、制作电子书的服务。',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              '如需定制服务，请联系作者获取更多信息。',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('联系作者'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('微信：shaogefenhao'),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Clipboard.setData(const ClipboardData(text: 'shaogefenhao'));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('微信号已复制到剪切板')),
                              );
                            },
                            child: const Text('复制到剪切板'),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('关闭'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('联系作者'),
            ),
          ],
        ),
      ),
    );
  }
}
