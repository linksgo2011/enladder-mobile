import 'dart:async';

import 'package:enladder_mobile/constants.dart';
import 'package:enladder_mobile/services/tts_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlashWordsDialog extends StatefulWidget {
  final String wordsUrl;
  final String? bookTitle;

  const FlashWordsDialog({
    Key? key,
    required this.wordsUrl,
    this.bookTitle,
  }) : super(key: key);

  @override
  _FlashWordsDialogState createState() => _FlashWordsDialogState();
}

class _FlashWordsDialogState extends State<FlashWordsDialog> {
  final ttsService = TtsService();
  List<Map<String, dynamic>> flashcards = [];
  int currentIndex = 0;
  int currentStage = 0; // 0: 单词, 1: 释义, 2: 朗读
  bool isPaused = false;
  int switchSpeed = 2000; // 切换速度，默认2000毫秒
  Timer? _timer; // Add a Timer reference
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchWords().then((_) => startFlashCards());
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  void startFlashCards() {
    _timer = Timer.periodic(Duration(milliseconds: switchSpeed), (timer) {
      if (!isPaused) {
        _nextFlashcard();
      }
    });
  }

  Future<void> _fetchWords() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl${widget.wordsUrl}"));

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedResponse);
        setState(() {
          flashcards = data is List
              ? data.cast<Map<String, dynamic>>()
              : data.values.toList();
        });
      } else {
        throw Exception('Failed to load words');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载单词失败: $e')),
      );
    }
  }

  void _nextFlashcard() {
    if (!isPaused) {
      setState(() {
        currentStage = (currentStage + 1) % 3;
        if (currentStage == 0) {
          currentIndex = (currentIndex + 1) % flashcards.length;
          _scrollToCurrentIndex();
        }
        if (currentStage == 2) {
          ttsService.speak(flashcards[currentIndex]['word']);
        }
      });
    }
  }

  void _scrollToCurrentIndex() {
    // Calculate the offset to center the current word
    double offset = (currentIndex * 100.0) -
        (MediaQuery.of(context).size.width / 2) +
        250.0;
    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final word = flashcards[currentIndex]['word'];
    final definition = flashcards[currentIndex]['definition'];
    final phonetic = flashcards[currentIndex]['phonetic'] ?? '';
    final mnemonic = flashcards[currentIndex]['mnemonic'] ?? '';

    return AlertDialog(
      title: Text('闪卡: ${widget.bookTitle ?? ''}'),
      actions: [
        TextButton(
          onPressed: () {
            // TODO 增加确认
            Navigator.of(context).pop();
          },
          child: Text('关闭'),
        ),
      ],
      content: Column(
        children: [
          SizedBox(
            height: 120,
            child: Column(
              children: [
                if (currentStage == 0)
                  Text(word, style: Theme.of(context).textTheme.titleSmall),
                if (currentStage == 1)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$word $phonetic\n'),
                        TextSpan(text: '$definition\n'),
                        if (mnemonic.isNotEmpty)
                          TextSpan(text: '助记: $mnemonic'),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                if (currentStage == 2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.volume_up),
                      Text('正在朗读: $word'),
                    ],
                  ),
              ],
            ),
          ),
          // 设置区
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<int>(
              value: switchSpeed,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    switchSpeed = value;
                  });
                }
              },
              items: const [
                DropdownMenuItem(value: 1000, child: Text('1 秒')),
                DropdownMenuItem(value: 2000, child: Text('2 秒')),
                DropdownMenuItem(value: 3000, child: Text('3 秒')),
                DropdownMenuItem(value: 4000, child: Text('4 秒')),
                DropdownMenuItem(value: 5000, child: Text('5 秒')),
              ],
            ),
          ),
          // 操作区
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  isPaused = !isPaused;
                });
              },
              child: Text(isPaused ? '继续' : '暂停'),
            ),
          ),
          // 单词进度
          SizedBox(
            width: double.infinity, // Full width of the parent
            height: 50.0, // Fixed height for the scrolling area
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: flashcards.map((flashcard) {
                  int index = flashcards.indexOf(flashcard);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = index;
                        currentStage = 0; // Reset to the word stage
                      });
                      _scrollToCurrentIndex();
                    },
                    child: Container(
                      width: 100.0, // Fixed width for each item
                      alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        color: index == currentIndex
                            ? Colors.blueAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        flashcard['word'],
                        style: TextStyle(
                          color: index == currentIndex
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Center(
            child: Text(
              '当前 ${currentIndex + 1} / 总数 ${flashcards.length}',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
