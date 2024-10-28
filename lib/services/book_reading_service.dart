import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BookReadingService {
  Future<Map<String, dynamic>> loadReadingPosition(String bookId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/reading_position_$bookId.json'; // Unique file for each book
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = jsonDecode(contents);
      print(data);
      return data;
    }
    return {
      'startCfi': null,
      'progress': 0.0
    };
  }

  Future<void> saveReadingPosition(String bookId, double progress, String startCfi) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/reading_position_$bookId.json'; // Unique file for each book
    final file = File(filePath);
    final data = {
      'startCfi': startCfi,
      'progress': progress
    };

    print("存储进度: $data");
    
    await file.writeAsString(jsonEncode(data));
  }
}