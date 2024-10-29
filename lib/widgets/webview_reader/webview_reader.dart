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
    required this.progress,
    required this.config,
  }) : super(key: key);

  final Book book;
  final File file; // The EPUB file
  final String? startCfi; 
  final double? progress;
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
    setState(() {
        progress = widget.progress ?? 0.0; 
        print("加载进度：$progress");
    }); 
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
          child: Column(
        children: [
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.transparent,
          ),
          Expanded(
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
        ],
      )),
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
        // 初次获得的进度值为 0 即使进度已经有了
        bookReadingService.saveReadingPosition(
          widget.book.id, 
          value.progress==0?progress:value.progress, 
          value.startCfi
        );
        setState(() {
          progress = value.progress==0?progress:value.progress;
        });
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
          epubController.clearSelections();
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
