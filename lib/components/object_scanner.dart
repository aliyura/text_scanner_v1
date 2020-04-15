import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file2text/components/progress_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class Scanner {
  AppProgressDialog dialog;
  final BuildContext context;
  final String apiKey = "af44179d3588957";

  Scanner({this.context}) {
    dialog = AppProgressDialog(context: context, title: "Scanning ... ");
  }

  sendRequest(File file) async {
    try {
      Response response;
      Dio dio = new Dio();
      String filename =
          file.path.substring(file.path.lastIndexOf("/")+1, file.path.length);

      FormData formData = FormData.fromMap({
        "apikey": apiKey,
        "language": "eng",
        "isOverlayRequired": true,
        "file": await MultipartFile.fromFile(file.path, filename: filename),
      });

      response = await dio.post(
        "https://api.ocr.space/parse/image",
        data: formData,
        onSendProgress: (int sent, int total) {
          double progress= sent / total * 100;
          dialog.update(progress);
        },
      );

      return response;
    } catch (ex) {
      print("Error occured:" + ex.toString());
      dialog.showError("Oops, and error occured!");
    }
  }

  Future<Map<String, String>> scan(File file) async {
    var client = new http.Client();
    int statusCode = 000;
    String resultSet = "";

    try {
      dialog.show();
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        Response response = await this.sendRequest(file);
        print(response.data);
        if (response.statusCode == 200) {
          statusCode = 001;
          dynamic data = response.data['ParsedResults'][0]['ParsedText'];
          resultSet=data;
        } else {
          statusCode = 000;
          dialog.showError(
              "Oops! error occured:" + response.statusCode.toString());
        }
      } else {
        dialog.showError("Unable to connect!");
      }
    } finally {
      dialog.hide();
      client.close();
    }
    return {"data": resultSet, "status": statusCode.toString()};
  }
}
