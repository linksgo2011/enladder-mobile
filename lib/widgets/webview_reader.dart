/**
 * 基于 Epub.js 实现的阅读器，被 lib/epub_viewer 再次封装
 */
import 'dart:io';

import 'package:enladder_mobile/models/book.dart';
import 'package:enladder_mobile/services/book_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

class WebviewReader extends StatefulWidget{
  WebviewReader({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<StatefulWidget> createState() => _WebviewReaderState();
}

class _WebviewReaderState extends State<WebviewReader>{

  final EpubController epubController = EpubController();
  final BookService _bookService = BookService();
 
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<String>(
          future: _bookService.getBookFilePath(widget.book), // 异步获取文件路径
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator()); // 显示加载图标
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // 显示错误信息
            } else if (snapshot.hasData) {
              final filePath = snapshot.data!;
              return Expanded(
                child: EpubViewer(
                  epubSource: EpubSource.fromFile(File(filePath)), // 使用获取到的 filePath
                  epubController: epubController,
                  displaySettings: EpubDisplaySettings(flow: EpubFlow.paginated, snap: true),
                  onChaptersLoaded: (chapters) {},
                  onEpubLoaded: () async {},
                  onRelocated: (value) {},
                  onTextSelected: (epubTextSelection) {},
                ),
              );
            }
            return const Center(child: Text('No data')); // 处理没有数据的情况
          },
        ),
      ),
    );
  }
}
