import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookDetailScreen extends StatelessWidget {
  final dynamic book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book['title']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookHeader(context),
            _buildBookInfo(context),
            _buildDescription(context),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBookHeader(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://app.enladder.com/${book['cover']}'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book['title'],
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                book['author'],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(context, '难度', book['difficulty']),
          _buildInfoItem(context, '语言', '英语'), // 假设所有书籍都是英语
          _buildInfoItem(context, '页数', '未知'), // 这里可以添加页数信息如果API提供
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '简介',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            book['description'],
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _openEpub(context),
              child: Text('开始阅读'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // 实现收藏功能
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('已添加到收藏')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // 实现分享功能
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('分享功能待实现')),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openEpub(BuildContext context) {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
    );
    
    // TODO 
    // VocsyEpub.open('https://app.enladder.com/${book['epubUrl']}');
    VocsyEpub.open('https://app.enladder.com/books/The%20Life%20and%20Adventures%20of%20Robinson%20Crusoe%20by%20Daniel%20Defoe/hints.epub');
  }
}
