import 'package:http/http.dart' as http;
import 'dart:convert';

class BookService {
  static const String _baseUrl = 'https://app.enladder.com/books/books.json';

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load books');
    }
  }
}