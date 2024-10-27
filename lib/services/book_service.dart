import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart'; // 导入 Book 模型

class BookService {
  static const String _baseUrl = 'https://app.enladder.com/books/books.json';
  static const String _bookshelfFileName = 'bookshelf.json';

  Future<List<Book>> fetchBooks() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> jsonList = json.decode(decodedResponse);
      return jsonList.map((json) => Book.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  Future<List<Book>> loadBooksFromBookshelf() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_bookshelfFileName';
    List<Book> bookshelf = [];

    // 检查文件是否存在
    if (FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      bookshelf = jsonList.map((json) => Book.fromJson(json)).toList();
    }

    return bookshelf;
  }

  Future<void> addBookToBookshelf(Book book) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_bookshelfFileName';
    List<Book> bookshelf = [];

    // 检查文件是否存在
    if (FileSystemEntity.typeSync(filePath) != FileSystemEntityType.notFound) {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      bookshelf = jsonList.map((json) => Book.fromJson(json)).toList();
    }

    // 添加新书籍到书架
    bookshelf.add(book);

    // 写入更新后的 JSON 文件
    final updatedJsonString = json.encode(bookshelf.map((b) => b.toJson()).toList());
    await File(filePath).writeAsString(updatedJsonString);
  }

  Future<void> clearBookshelf() async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$_bookshelfFileName';
    final file = File(filePath);

    // 检查文件是否存在
    if (await file.exists()) {
      await file.writeAsString('[]'); // 清空文件内容，写入空数组
    }
  }

  Future<bool> isBookInBookshelf(String title) async {
    final books = await loadBooksFromBookshelf();
    return books.any((book) => book.title == title);
  }

  Future<void> downloadBook(String epubUrl, String title) async {
    final response = await http.get(Uri.parse(epubUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$title.epub';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
    } else {
      throw Exception('下载失败');
    }
  }
  
  Future<String> getBookFilePath(Book book) async {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/${book.title}.epub';
    return filePath;
  }
}
