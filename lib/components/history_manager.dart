import 'dart:io';

import 'package:file2text/components/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:file2text/components/text_preview.dart';
import 'package:file2text/components/result_manager.dart';

class HistoryPreview extends StatelessWidget {
  final List<Object> list;
  final File inputFile;
  HistoryPreview({this.list, this.inputFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: list == null || list.length <= 0
          ? TextPreview(textResult: "No Conversion History")
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, position) {
                List<String> history = list[position].toString().split("~|");

                String filename = history[0].trim();
                String result = history[1].trim();
                String date = history[2].trim();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Text(filename),
                      subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(date),
                            SizedBox(height: 20),
                            Text(result),
                            SizedBox(height: 20),
                            Row(children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    ResultManager(context, inputFile)
                                        .copyText(result);
                                  },
                                  child: Icon(
                                    Icons.content_copy,
                                    color:
                                        AppTheme.nearlyBlack.withOpacity(0.5),
                                  )),
                              SizedBox(width: 20),
                              GestureDetector(
                                  onTap: () {
                                    ResultManager(context, inputFile)
                                        .shareText(result);
                                  },
                                  child: Icon(Icons.exit_to_app,
                                      color: AppTheme.nearlyBlack
                                          .withOpacity(0.5))),
                              SizedBox(width: 20),
                              GestureDetector(
                                  onTap: () {
                                    ResultManager(context, inputFile)
                                        .saveText(result);
                                  },
                                  child: Icon(Icons.save_alt,
                                      color: AppTheme.nearlyBlack
                                          .withOpacity(0.5))),
                            ])
                          ]),
                      leading: Container(
                        child: Image.asset("assets/images/doc.png"),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class HistoryManager {
  SharedPreferences prefs;

  HistoryManager() {
    initilizeStorage();
  }

  initilizeStorage() async {
    prefs = await SharedPreferences.getInstance();
  }

  add(String history) async {
    prefs = await SharedPreferences.getInstance();
    List<String> list = new List();
    String historyDump =  prefs.getString("history");

    if (historyDump == null || historyDump == "[]") {
       list.add(history);
    } else {
      historyDump = historyDump.replaceAll("[", "").replaceAll("]", "");
      list.add(historyDump);
      list.add(history);
    }
    return await prefs.setString("history", list.toString());
  }
}
