import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tscanner/components/themes.dart';
import 'package:photo_view/photo_view.dart';

class ObjectPreview extends StatelessWidget {
  final File imageFile;
  final String fileTitle;

  ObjectPreview({this.imageFile, this.fileTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: imageFile != null
          ? PhotoView(
              maxScale: PhotoViewComputedScale.contained * 0.8,
              initialScale: PhotoViewComputedScale.contained * 0.8,
              imageProvider: FileImage(imageFile))
          : Center(
              child: Container(
              width: 200,
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 100),
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Text(
                    fileTitle,
                    style: TextStyle(color: AppTheme.grey, fontSize: 16),
                  )
                ],
              ),
            )),
    );
  }
}
