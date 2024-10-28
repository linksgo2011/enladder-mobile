import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordLookupDialog extends StatelessWidget {
  final String word;
  final FlutterTts flutterTts;

  const WordLookupDialog({
    Key? key,
    required this.word,
    required this.flutterTts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("查词：$word"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              _pronounceWord(word);
            },
            child: Text('发音'),
          ),
          SizedBox(height: 10),
          // Here you can implement a translation service or API call
          ElevatedButton(
            onPressed: () {
              _translateWord(word);
            },
            child: Text('释义(开发中)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('关闭'),
        ),
      ],
    );
  }

  void _pronounceWord(String word) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(word);
  }

  void _translateWord(String word) async {
    // Implement your translation logic here
    print('Translating: $word');
    // You can use a translation API or service
  }
}