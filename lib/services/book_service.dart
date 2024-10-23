import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BookService {
  static const String _baseUrl = 'https://app.enladder.com/books/books.json';
  static const String _bookshelfFileName = 'bookshelf.json';

  Future<List<dynamic>> fetchBooks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      return json.decode(decodedResponse);
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<dynamic>> loadBooksFromBookshelf() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_bookshelfFileName';
    List<dynamic> bookshelf = [];

    // 检查文件是否存在
    if (FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      bookshelf = json.decode(jsonString);
    }

    return bookshelf;
  }

  Future<void> addBookToBookshelf(dynamic book) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_bookshelfFileName';
    List<dynamic> bookshelf = [];

    // 检查文件是否存在
    if (FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      bookshelf = json.decode(jsonString);
    }

    // 添加新书籍到书架
    bookshelf.add(book);

    // 写入更新后的 JSON 文件
    final updatedJsonString = json.encode(bookshelf);
    await File(filePath).writeAsString(updatedJsonString);
  }
}
