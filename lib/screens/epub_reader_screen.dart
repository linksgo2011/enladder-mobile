import 'package:flutter/material.dart';
import 'package:epubx/epubx.dart';

class EpubReaderScreen extends StatefulWidget {
  final EpubBook epubBook;

  const EpubReaderScreen({Key? key, required this.epubBook}) : super(key: key);

  @override
  _EpubReaderScreenState createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.epubBook.Title ?? 'eBook Reader'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.epubBook.Chapters?[_currentIndex].HtmlContent ?? '',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Previous',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Next',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          if (index == 0 && _currentIndex > 0) {
            setState(() {
              _currentIndex--;
            });
          } else if (index == 1 && _currentIndex < (widget.epubBook.Chapters?.length ?? 1) - 1) {
            setState(() {
              _currentIndex++;
            });
          }
        },
      ),
    );
  }
}

