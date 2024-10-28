import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BookReadingService {
  Future<String?> loadReadingPosition(String bookId) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/reading_position_$bookId.json'; // Unique file for each book
    final file = File(filePath);

    if (await file.exists()) {
      final contents = await file.readAsString();
      final data = jsonDecode(contents);
      return data['startCfi'];
    }
    return null; // Return null if no saved position
  }

  Future<void> saveReadingPosition(String bookId, double progress, String startCfi) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/reading_position_$bookId.json'; // Unique file for each book
    final file = File(filePath);
    final data = {
      'startCfi': startCfi,
      'progress': progress
    };
    await file.writeAsString(jsonEncode(data));
  }
}