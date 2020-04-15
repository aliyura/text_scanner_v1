import 'package:flutter/material.dart';
import 'package:file2text/components/themes.dart';

class TextPreview extends StatelessWidget {
  final String textResult;
  TextPreview({@required this.textResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.all(15),
      child: textResult != "No Conversion Yet" &&
              textResult != "No Conversion History"
          ? SingleChildScrollView(
              child: Text(
              textResult,
              overflow: TextOverflow.clip,
            ))
          : Center(child: Text(textResult)),
    );
  }
}
