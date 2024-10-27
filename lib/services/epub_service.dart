import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class EpubService {
  void openEpub(String title, {bool useEpubjs = false}) async {
    if (useEpubjs) {
      _openEpubWithJS(title);
    } else {
      _openEpubWithVocsy(title);
    }
  }

  void _openEpubWithVocsy(String title) async {
    VocsyEpub.setConfig(
      themeColor: Colors.blue, // 可以根据需要自定义颜色
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.HORIZONTAL,
      allowSharing: true,
      enableTts: true,
    );

    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$title.epub';
    VocsyEpub.open(filePath);
  }

  void _openEpubWithJS(String title) async {
    
   }
}