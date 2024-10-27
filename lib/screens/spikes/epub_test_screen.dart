import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:flutter/material.dart';


class EpubTestScreen extends StatefulWidget {
  const EpubTestScreen({super.key});

  @override
  State<EpubTestScreen> createState() => _TestStateState();
}

class _TestStateState extends State<EpubTestScreen> {

  final epubController = EpubController();

  var textSelectionCfi = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: EpubViewer(
              epubSource: EpubSource.fromUrl(
                  'http://enladder.shaogefenhao.com/books/The%20Life%20and%20Adventures%20of%20Robinson%20Crusoe%20by%20Daniel%20Defoe/hints.epub'),
              epubController: epubController,
              displaySettings:
                  EpubDisplaySettings(flow: EpubFlow.paginated, snap: true),
              onChaptersLoaded: (chapters) {},
              onEpubLoaded: () async {},
              onRelocated: (value) {},
              onTextSelected: (epubTextSelection) {},
            ),
          ),
        ],
      )),
    );
  }
}

