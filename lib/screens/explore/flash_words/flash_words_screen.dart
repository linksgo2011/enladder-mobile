import 'package:enladder_mobile/constants.dart';
import 'package:enladder_mobile/models/word_book.dart';
import 'package:enladder_mobile/screens/explore/flash_words/flash_words_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FlashWordsScreen extends StatefulWidget {
  const FlashWordsScreen({Key? key}) : super(key: key);

  @override
  _FlashWordsScreenState createState() => _FlashWordsScreenState();
}

class _FlashWordsScreenState extends State<FlashWordsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WordBook> _highFrequencyWordBooks = [];
  List<WordBook> _bookWordBooks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadHighFrequencyWordBooks();
    _loadBookWordBooks();
  }

  Future<void> _loadHighFrequencyWordBooks() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _highFrequencyWordBooks = [
        WordBook(
          id: 'frequency-word-books-1',
          title: '0 - 1000 现代语料高频单词',
          wordsUrl: './books/frequency-word/0-1000words.json',
          author: 'shaogefenhao',
        ),
        WordBook(
          id: 'frequency-word-books-2',
          title: '1000 - 2000 现代语料高频单词',
          wordsUrl: './books/frequency-word/1000-2000words.json',
          author: 'shaogefenhao',
        ),
        WordBook(
          id: 'frequency-word-books-3',
          title: '2000 - 3000 现代语料高频单词',
          wordsUrl: './books/frequency-word/2000-3000words.json',
          author: 'shaogefenhao',
        ),
        WordBook(
          id: 'frequency-word-books-4',
          title: '3000 - 4000 现代语料高频单词',
          wordsUrl: './books/frequency-word/3000-4000words.json',
          author: 'shaogefenhao',
        ),
        WordBook(
          id: 'frequency-word-books-5',
          title: '4000 - 5000 现代语料高频单词',
          wordsUrl: './books/frequency-word/4000-5000words.json',
          author: 'shaogefenhao',
        ),
      ];
      _isLoading = false;
    });
  }

  Future<void> _loadBookWordBooks() async {
    // Replace with your wordsUrl
    final wordsUrl = wordBooksUrl;
    try {
      final response = await http.get(Uri.parse(wordsUrl));
      if (response.statusCode == 200) {
        setState(() {
          _bookWordBooks = (jsonDecode(response.body) as List)
              .map((json) => WordBook.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load book words');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载书籍单词失败: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('闪记单词'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '高频 5000'),
            Tab(text: '书籍单词'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildWordBooksList(_highFrequencyWordBooks),
                _buildWordBooksList(_bookWordBooks),
              ],
            ),
    );
  }

  Widget _buildWordBooksList(wordBooks) {
    return ListView.builder(
      itemCount: wordBooks.length,
      itemBuilder: (context, index) {
        final wordBook = wordBooks[index];
        return ListTile(
          title: Text(wordBook.title),
          subtitle: Text("作者：${wordBook.title}"),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return FlashWordsDialog( wordsUrl: wordBook.wordsUrl, bookTitle: wordBook.title);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}