import 'package:enladder_mobile/models/book.dart';
import 'package:enladder_mobile/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/book_service.dart';
import '../../services/epub_service.dart';
import 'book_reader_screen.dart';
import '../../constants.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final BookService _bookService = BookService();
  final EpubService _epubService = EpubService();
  bool _isBookInBookshelf = false;

  @override
  void initState() {
    super.initState();
    _checkBookInBookshelf();
  }

  Future<void> _checkBookInBookshelf() async {
    final isInBookshelf = await _bookService.isBookInBookshelf(widget.book.title);
    setState(() {
      _isBookInBookshelf = isInBookshelf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
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
          image: NetworkImage('$baseUrl${widget.book.cover}'),
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
                widget.book.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                widget.book.author,
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
          _buildInfoItem(context, '难度', widget.book.difficulty),
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
            widget.book.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          if (_isBookInBookshelf)
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookReaderScreen(book: widget.book))),
              child: Text('本地阅读'),
            )
          else ...[
            ElevatedButton(
              onPressed: () async {
                try {
                  LoadingDialog.show(context);
                  await _bookService.downloadBook('$epubBaseUrl${widget.book.epubUrl}', widget.book.title);
                  await _bookService.addBookToBookshelf(widget.book);
                  LoadingDialog.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('书籍已添加到书架并下载成功')),
                  );
                  _checkBookInBookshelf(); // 刷新书架状态
                } catch (e) {
                  LoadingDialog.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('下载失败: $e')),
                  );
                }
              },
              child: Text('添加书架'),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    LoadingDialog.show(context);
                    await _bookService.downloadBook('$epubBaseUrl${widget.book.epubUrl}', widget.book.title);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookReaderScreen(book: widget.book)));
                    LoadingDialog.hide(context);
                  } catch (e) {
                    LoadingDialog.hide(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('下载失败: $e')),
                    );
                  }
                },
                child: Text('在线阅读'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
