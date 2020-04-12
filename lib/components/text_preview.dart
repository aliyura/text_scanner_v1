import 'package:flutter/material.dart';
import 'package:tscanner/components/themes.dart';

class TextPreview extends StatelessWidget {
  final String textResult;
  TextPreview({@required this.textResult});

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      width: double.infinity,
      color: AppTheme.white,
      padding: EdgeInsets.all(15),
      child:
      textResult=="Take file to Scan"?
       Text(
        textResult,
        overflow: TextOverflow.clip,
      ):Center(
        child:Text(textResult)
      ),
    );
  }
}
