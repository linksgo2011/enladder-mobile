import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WordsService {
  // Method to get the local file for storing progress
  Future<File> _getLocalFile(String wordsBookId) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'word_progress_${base64Url.encode(utf8.encode(wordsBookId))}'; // Encode book ID to a safe file name with prefix
    return File('${directory.path}/$fileName.json');
  }

  // Method to load the progress of flashcards
  Future<int> loadProgress(String wordsBookId) async {
    try {
      final file = await _getLocalFile(wordsBookId);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = jsonDecode(contents);
        return data['currentIndex'] ?? 0;
      }
    } catch (e) {
      // Handle any errors that might occur during file read
      print('Error loading progress: $e');
    }
    return 0; // Default to starting from the beginning
  }

  // Method to save the progress of flashcards
  Future<void> saveProgress(String wordsBookId, int currentIndex) async {
    print("save progress $currentIndex");
    
    try {
      final file = await _getLocalFile(wordsBookId);
      final data = {'currentIndex': currentIndex};
      await file.writeAsString(jsonEncode(data));
    } catch (e) {
      // Handle any errors that might occur during file write
      print('Error saving progress: $e');
    }
  }
}
