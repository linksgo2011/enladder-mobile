import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../widgets/webview_reader/webview_reader.dart';
import '../../services/book_service.dart';
import '../../services/profile_service.dart';
import '../../services/book_reading_service.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookReaderScreen> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReaderScreen> {
  final BookService _bookService = BookService();
  final ProfileService _profileService = ProfileService();
  final BookReadingService _bookReadingService = BookReadingService();

  late Future<Map<String, dynamic>> _readerConfig;

  @override
  void initState() {
    super.initState();
    _readerConfig = _initializeReader();
  }

  Future<Map<String, dynamic>> _initializeReader() async {
    final file = await _bookService.getBookFile(widget.book);
    var readdingPosition = await _bookReadingService.loadReadingPosition(widget.book.id);
    final config = await _profileService.getAllConfigurations();

    return {
      'file': file,
      'startCfi': readdingPosition['startCfi'] as String?,
      'progress': readdingPosition['progress'] as double?,
      'config': config,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _readerConfig,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          return WebviewReader(
            book: widget.book,
            file: data['file'],
            startCfi: data['startCfi'],
            progress: data['progress'],
            config: data['config'],
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
