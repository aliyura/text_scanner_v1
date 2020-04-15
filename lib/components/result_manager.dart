import 'dart:io';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:file2text/components/file_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:share/share.dart';

class ResultManager{

  BuildContext context;
  File inputFile;

  ResultManager(BuildContext context,File file){
     this.context=context;
     this.inputFile=file;
  }
  
  void copyText(String text) {
    ClipboardManager.copyToClipBoard(text);
    Toast.show(" Copied ", context);
  }

  void saveText(String text) async {
    String path = inputFile.path;
    String filename =
        path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf(".")) +
            ".txt";
    FileManager manager = FileManager(filename);
    manager.saveFile(text);
    Toast.show("Saved " + filename, context);
  }

  void shareText(String text) async {
    Share.share(text);
  }

}