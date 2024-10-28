/**
 * 基于 Epub.js 实现的阅读器，被 lib/epub_viewer 再次封装
 */
import 'dart:io';
import 'dart:convert';
import 'package:enladder_mobile/services/profile_service.dart';
import 'package:enladder_mobile/widgets/webview_reader/word_lookup_dialog.dart';
import 'package:path_provider/path_provider.dart';

import 'package:enladder_mobile/models/book.dart';
import 'package:enladder_mobile/services/book_service.dart';
import 'package:enladder_mobile/services/book_reading_service.dart';
import 'package:enladder_mobile/widgets/webview_reader/chapter_drawer.dart';
import 'package:enladder_mobile/widgets/webview_reader/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WebviewReader extends StatefulWidget {
  WebviewReader({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<StatefulWidget> createState() => _WebviewReaderState();
}

class _WebviewReaderState extends State<WebviewReader> {
  final bookService = BookService();
  final profileService = ProfileService();
  final bookReadingService = BookReadingService();
  final epubController = EpubController();
  final FlutterTts flutterTts = FlutterTts();
  String textSelection = '';
  bool isLoading = true;
  // 用于展示进度
  double progress = 0.0;

  late Future<Map<String, dynamic>> combinedFuture;

  @override
  void initState() {
    super.initState();
    combinedFuture = _initializeReader(); // Combine the futures
  }

  Future<Map<String, dynamic>> _initializeReader() async {
    final file = await bookService.getBookFile(widget.book);
    final startCfi = await bookReadingService.loadReadingPosition(widget.book.id);
    final config = await profileService.getAllConfigurations();
    
    print(config);
    
    return {
      'file': file,
      'startCfi': startCfi,
      'config': config
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ChapterDrawer(
        controller: epubController,
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchPage(
                            epubController: epubController,
                          )));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: combinedFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final file = snapshot.data!['file'] as File;
              final startCfi = snapshot.data!['startCfi'] as String?;
              final config = snapshot.data!['config'] as Map<String, dynamic>;
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        _buildEpubViewer(file, startCfi, config),
                        if (isLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildEpubViewer(File file, String? startCfi, Map<String, dynamic> config) {
    print("Open book ${file.path} cfi: ${startCfi}");
    
    return EpubViewer(
      epubSource: EpubSource.fromFile(file), // 使用文件路径打开
      epubController: epubController,
      initialCfi: startCfi,
      displaySettings: EpubDisplaySettings(
        fontSize: config['fontSize'],
        theme: config['theme'],
        flow: EpubFlow.paginated,
        snap: true,
        allowScriptedContent: false,
      ),
      selectionContextMenu: ContextMenu(
        menuItems: _buildContextMenuItems(),
        settings: ContextMenuSettings(
          hideDefaultSystemContextMenuItems: true,
        ),
      ),
      onChaptersLoaded: (chapters) {
        setState(() {
          isLoading = false;
        });
      },
      onEpubLoaded: () async {
        setState(() {
          isLoading = false;
        });
        print('Epub loaded');
      },
      onRelocated: (value) {
        setState(() {
          progress = value.progress;
        });
        bookReadingService.saveReadingPosition(widget.book.id, value.progress, value.startCfi);
      },
      onAnnotationClicked: (cfi) {
        print("Annotation clicked $cfi");
      },
      onTextSelected: (epubTextSelection) {
        textSelection = epubTextSelection.selectedText;
      },
    );
  }

  List<ContextMenuItem> _buildContextMenuItems() {
    return [
      ContextMenuItem(
        title: "查词",
        id: 1,
        action: () async {
          _showWordLookupDialog(textSelection);
        },
      ),
    ];
  }

  void _showWordLookupDialog(String word) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WordLookupDialog(
          word: word,
          flutterTts: flutterTts, // Pass the FlutterTts instance
        );
      },
    );
  }
}