import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file2text/components/themes.dart';

class ObjectPreview extends StatelessWidget {
  final File file;
  final String fileTitle;

  ObjectPreview({this.file, this.fileTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: file != null
          ? Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              color: AppTheme.nearlyBlack,
              child: file.path.endsWith(".pdf")
                  ? Image.asset("assets/images/pdf.png")
                  : file.path.endsWith(".doc")
                      ? Image.asset("assets/images/doc.png")
                      : (file.path.endsWith(".jpg") ||
                              file.path.endsWith(".png") ||
                              file.path.endsWith(".jpeg"))
                          ? Image.file(file)
                          : builtText(context, fileTitle))
          : builtText(context, fileTitle),
    );
  }

  Widget builtText(BuildContext context, String text) {
    return Center(
        child: Container(
      width: 200,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 100),
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Text(
            fileTitle,
            style: TextStyle(color: AppTheme.grey, fontSize: 16),
          )
        ],
      ),
    ));
  }
}
