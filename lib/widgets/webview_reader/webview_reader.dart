/**
 * 基于 Epub.js 实现的阅读器，被 lib/epub_viewer 再次封装
 */
import 'dart:io';
import 'package:enladder_mobile/services/book_reading_service.dart';
import 'package:enladder_mobile/widgets/webview_reader/word_lookup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:enladder_mobile/models/book.dart';
import 'package:enladder_mobile/widgets/webview_reader/chapter_drawer.dart';
import 'package:enladder_mobile/widgets/webview_reader/search_page.dart';

class WebviewReader extends StatefulWidget {
  const WebviewReader({
    Key? key,
    required this.book,
    required this.file,
    required this.startCfi,
    required this.config,
  }) : super(key: key);

  final Book book;
  final File file; // The EPUB file
  final String? startCfi; // The starting CFI for reading
  final Map<String, dynamic> config; // Configuration settings

  @override
  State<StatefulWidget> createState() => _WebviewReaderState();
}

class _WebviewReaderState extends State<WebviewReader> {
  final EpubController epubController = EpubController();
  final FlutterTts flutterTts = FlutterTts();
  final bookReadingService = BookReadingService();
  String textSelection = '';
  bool isLoading = true;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
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
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            _buildEpubViewer(),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpubViewer() {
    return EpubViewer(
      epubSource: EpubSource.fromFile(widget.file),
      epubController: epubController,
      initialCfi: widget.startCfi,
      displaySettings: EpubDisplaySettings(
        fontSize: widget.config['fontSize'],
        theme: widget.config['theme'],
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
      onEpubLoaded: () {
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
