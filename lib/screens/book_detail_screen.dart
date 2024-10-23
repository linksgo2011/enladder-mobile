import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/book_service.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;
  final BookService _bookService = BookService();

   BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookHeader(context),
            _buildBookInfo(context),
            _buildDescription(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://app.enladder.com/${book['cover']}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book['title'],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                book['author'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(context, '难度', book['difficulty']),
          _buildInfoItem(context, '语言', '英语'), // 假设所有书籍都是英语
          _buildInfoItem(context, '页数', '未知'), // 这里可以添加页数信息如果API提供
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '简介',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            book['description'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder<bool>(
        future: _isBookDownloaded(book['title']),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData && snapshot.data!) {
            return ElevatedButton(
              onPressed: () => _openEpub(context),
              child: Text('本地阅读'),
            );
          } else {
            return Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _downloadEpub(context);
                    await _bookService.addBookToBookshelf(book);
                  },
                  child: Text('添加书架'),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openEpub(context),
                    child: Text('在线阅读'),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<bool> _isBookDownloaded(String title) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${title}.epub';
    final file = File(filePath);
    return file.existsSync();
  }

  Future<void> _downloadEpub(BuildContext context) async {
    final epubUrl = 'https://app.enladder.com/${book['epubUrl']}';
    final response = await http.get(Uri.parse(epubUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${book['title']}.epub';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载成功: ${book['title']}.epub')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载失败，请重试')),
      );
    }
  }

  void _openEpub(BuildContext context) async {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
    );

    final epubUrl = 'https://app.enladder.com/${book['epubUrl']}';
    final response = await http.get(Uri.parse(epubUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/book.epub';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      VocsyEpub.open(filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载失败，请重试')),
      );
    }
  }
}
