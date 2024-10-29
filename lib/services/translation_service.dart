import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  Future<List<dynamic>> fetchWordDetails(String word) async {
    final response = await http.get(Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$word'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // 返回 List<dynamic>
    } else {
      throw Exception('Failed to load word details');
    }
  }
}