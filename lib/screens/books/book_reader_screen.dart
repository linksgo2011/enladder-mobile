import 'package:flutter/material.dart';

import '../../models/book.dart';
import '../../widgets/webview_reader/webview_reader.dart';

class BookReaderScreen extends StatefulWidget {
  const BookReaderScreen({super.key, required this.book});

  final Book book;

  @override
  State<BookReaderScreen> createState() => _BookReaderState();
}

class _BookReaderState extends State<BookReaderScreen> {
  @override
  Widget build(BuildContext context) {
    return WebviewReader(book: widget.book);
  }
}