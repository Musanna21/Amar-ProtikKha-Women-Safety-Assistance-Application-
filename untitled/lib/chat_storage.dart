import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

// This class will store all chat in ai_chat_history.txt which will be located in 'Document' folder in desktops and app data in android or ios.

class ChatStorage {
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/ai_chat_history.txt');
  }

  Future<void> saveHistory(List<Map<String, String>> history) async {
    final file = await _localFile;
    final lastMessage = history.last;
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    
    // Append only the latest exchange to the .txt file
    String logEntry = "[$timestamp] ${lastMessage['role'].toString().toUpperCase()}: ${lastMessage['text']}\n";
    await file.writeAsString(logEntry, mode: FileMode.append);
  }

  // Helper to read the log for the AI if needed
  Future<String> readFullLog() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return "";
    }
  }
}