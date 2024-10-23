import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  Future<void> _openEpub(BuildContext context, String url, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    if (!await file.exists()) {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
    }

    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
    );
    
    VocsyEpub.open(filePath);
  }

  @override
  Widget build(BuildContext context) {
    final books = [
      {'title': '书籍1', 'url': 'http://enladder.shaogefenhao.com/books/The%20Life%20and%20Adventures%20of%20Robinson%20Crusoe%20by%20Daniel%20Defoe/hints.epub'},
      {'title': '书籍2', 'url': 'https://example.com/book2.epub'},
      {'title': '书籍3', 'url': 'https://example.com/book3.epub'},
    ];

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(books[index]['title']!),
          onTap: () => _openEpub(
            context,
            books[index]['url']!,
            'book_${index + 1}.epub',
          ),
        );
      },
    );
  }
}
