library epub_reader;

import 'package:flutter/material.dart';

abstract class EpubReader extends StatelessWidget {
  const EpubReader({super.key});

  /// Load an EPUB file from a URL
  Future<void> loadFromUrl(String url);

  /// Load an EPUB file from local storage
  Future<void> loadFromFile(String filePath);

  /// Set the display settings for the EPUB viewer
  void setDisplaySettings(EpubDisplaySettings settings);

  /// Callback when the EPUB is loaded
  void onEpubLoaded();

  /// Callback when chapters are loaded
  void onChaptersLoaded(List<EpubChapter> chapters);

  /// Callback when text is selected
  void onTextSelected(EpubTextSelection selection);
}