import 'dart:convert';
import 'package:enladder_mobile/constants.dart';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class ArticleService {
  static const String _url = '$baseUrl/audio-articles/articles.json';

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonData = json.decode(decodedResponse);
      return jsonData.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}