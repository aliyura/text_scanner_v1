import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:file2text/components/themes.dart';

class AppProgressDialog {
  final title;
  final BuildContext context;
  ProgressDialog pr;

  AppProgressDialog({@required this.title, @required this.context}) {
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
        message: title,
        borderRadius: 10.0,
        backgroundColor: AppTheme.white,
        progressWidget: Container(
            height: 50,
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600));
  }

  showError(error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Text Scanner"),
          content: Text(error),
        );
      },
    );
  }

  update(double progress) {
    pr.update(
      progress: progress,
      message: "Please wait...",
    );
  }

  show() {
    pr.show();
  }

  hide() {
    pr.hide();
  }
}
