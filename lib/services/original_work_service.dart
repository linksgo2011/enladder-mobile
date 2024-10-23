import 'package:http/http.dart' as http;
import 'dart:convert';

class OriginalWorkService {
  static const String _baseUrl = 'https://app.enladder.com/books/original_works.json';

  Future<List<dynamic>> fetchOriginalWorks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load original works');
    }
  }
}

