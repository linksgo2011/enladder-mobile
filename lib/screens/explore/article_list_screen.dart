import 'package:enladder_mobile/constants.dart';
import 'package:enladder_mobile/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import '../../models/article.dart';
import '../../services/article_service.dart';

class ArticleListScreen extends StatefulWidget {
  ArticleListScreen({Key? key}) : super(key: key);

  @override
  _ArticleListScreenState createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends State<ArticleListScreen> {
  final ArticleService _articleService = ArticleService();
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = _articleService.fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('短文阅读'),  
      ),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No articles found'));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.cnTitle),
                  subtitle: Text(article.title),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          url: "$baseUrl${article.fileUrl}",
                          title: article.cnTitle
                          ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}