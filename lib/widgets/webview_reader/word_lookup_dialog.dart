import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/translation_service.dart'; // Import the TranslationService

class WordLookupDialog extends StatefulWidget {
  final String word;
  final FlutterTts flutterTts;

  const WordLookupDialog({
    Key? key,
    required this.word,
    required this.flutterTts,
  }) : super(key: key);

  @override
  _WordLookupDialogState createState() => _WordLookupDialogState();
}

class _WordLookupDialogState extends State<WordLookupDialog> {
  final TranslationService _translationService = TranslationService();
  List<dynamic>? _wordDetails; // Change to List<dynamic>
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWordDetails();
  }

  Future<void> _fetchWordDetails() async {
    try {
      final details = await _translationService.fetchWordDetails(widget.word);
      setState(() {
        _wordDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("查词：${widget.word}"),
      content: _isLoading
          ? SizedBox(
              height: 100, // Set a smaller height for the loading state
              child: const Center(child: CircularProgressIndicator()),
            )
          : _wordDetails != null && _wordDetails!.isNotEmpty
              ? SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300), // Set max height
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () {
                            _pronounceWord(widget.word);
                          },
                        ),
                        SizedBox(height: 10),
                        Text('音标: ${_wordDetails![0]['phonetics'].isEmpty ? '无' : _wordDetails![0]['phonetics'][0]['text']}'),
                        SizedBox(height: 10),
                        Text('释义: ${_wordDetails![0]['meanings'][0]['definitions'][0]['definition']}'),
                        SizedBox(height: 10),
                        Text('例句: ${_wordDetails![0]['meanings'][0]['definitions'][0]['example'] ?? '无'}'),
                      ],
                    ),
                  ),
                )
              : Text('未找到该单词的详细信息'),
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
    await widget.flutterTts.setLanguage("en-US");
    await widget.flutterTts.setPitch(1.0);
    await widget.flutterTts.speak(word);
  }
}