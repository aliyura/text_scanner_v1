import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileManager {
  String filename;
  FileManager(String filename) {
    this.filename = filename;
  }

  Future<String> get getFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get getFile async {
    final path = await getFilePath;
    return File('$path/' + filename);
  }

  Future<File> saveFile(String data) async {
    final file = await getFile;
    return file.writeAsString(data);
  }
}
