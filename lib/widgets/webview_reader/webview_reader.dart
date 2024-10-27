/**
 * 基于 Epub.js 实现的阅读器，被 lib/epub_viewer 再次封装
 */
import 'dart:io';

import 'package:enladder_mobile/models/book.dart';
import 'package:enladder_mobile/services/book_service.dart';
import 'package:enladder_mobile/widgets/webview_reader/chapter_drawer.dart';
import 'package:enladder_mobile/widgets/webview_reader/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';

class WebviewReader extends StatefulWidget {
  WebviewReader({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<StatefulWidget> createState() => _WebviewReaderState();
}

class _WebviewReaderState extends State<WebviewReader> {
  final bookService = BookService();
  final epubController = EpubController();
  var textSelectionCfi = '';
  bool isLoading = true;
  double progress = 0.0;
  late Future<File> bookFile;

  @override
  void initState() {
    super.initState();
    bookFile = bookService.getBookFile(widget.book); // Fetch the file asynchronously
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
        child: FutureBuilder<File>(
          future: bookFile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final file = snapshot.data!;
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.transparent,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        EpubViewer(
                          epubSource: EpubSource.fromFile(file), // 使用文件路径打开
                          epubController: epubController,
                          displaySettings: EpubDisplaySettings(
                            fontSize: 24,
                            flow: EpubFlow.paginated,
                            snap: true,
                            allowScriptedContent: false,
                          ),
                          selectionContextMenu: ContextMenu(
                            menuItems: [
                              ContextMenuItem(
                                title: "Highlight",
                                id: 1,
                                action: () async {
                                  epubController.addHighlight(cfi: textSelectionCfi);
                                },
                              ),
                            ],
                            settings: ContextMenuSettings(
                                hideDefaultSystemContextMenuItems: true),
                          ),
                          onChaptersLoaded: (chapters) {
                            setState(() {
                              isLoading = false;
                            });
                          },
                          onEpubLoaded: () async {
                            print('Epub loaded');
                          },
                          onRelocated: (value) {
                            setState(() {
                              progress = value.progress;
                            });
                          },
                          onAnnotationClicked: (cfi) {
                            print("Annotation clicked $cfi");
                          },
                          onTextSelected: (epubTextSelection) {
                            textSelectionCfi = epubTextSelection.selectionCfi;
                            print(textSelectionCfi);
                          },
                        ),
                        Visibility(
                          visible: isLoading,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
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
}
