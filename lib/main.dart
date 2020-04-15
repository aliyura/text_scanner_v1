
import 'package:file2text/components/history_manager.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file2text/components/object_preview.dart';
import 'package:file2text/components/object_scanner.dart';
import 'package:file2text/components/text_preview.dart';
import 'package:file2text/components/themes.dart';
import 'package:file2text/screens/about.dart';
import 'package:file2text/screens/feedback.dart';
import 'package:file2text/screens/invite_friend.dart';
import 'package:file2text/screens/rate_app.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/result_manager.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File to Text',
      theme: new ThemeData(
        primaryColor: AppTheme.background,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      home: SplashScreen(
          seconds: 5,
          image: Image.asset('assets/images/logo.png'),
        photoSize: 30,
        title:  Text('File to Text',style: TextStyle(color: AppTheme.white,fontWeight: FontWeight.bold,
        fontSize: 20.0)),
          navigateAfterSeconds: MyApp(),
          backgroundColor: AppTheme.background,
          loaderColor: AppTheme.white
        ),
      color: AppTheme.white,
      debugShowCheckedModeBanner: false,
    );
  }
}

enum AppState {
  free,
  picked,
  cropped,
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppState state;
  File inputFile;
  String fileTitle;
  String textResult;
  int currentPosition = 3;
  int scanningStatus = 0;
  List<Object> history = new List();

  @override
  void initState() {
    state = AppState.free;
    fileTitle = "Browse File";
    textResult = "No Conversion Yet";
    _refreshHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppTheme.white,
        appBar: AppBar(
          title: Text("File to Text"),
          actions: <Widget>[
            SizedBox(width: 20),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => InviteFriend()));
                },
                child: Icon(Icons.share, color: AppTheme.white, size: 20)),
            SizedBox(width: 40),
            GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FeedbackScreen()));
                },
                child: Icon(Icons.comment, color: AppTheme.white, size: 20)),
            SizedBox(width: 20),
          ],
        ),
        bottomNavigationBar: FancyBottomNavigation(
          circleColor: AppTheme.white,
          activeIconColor: AppTheme.background,
          barBackgroundColor: AppTheme.background,
          textColor: AppTheme.white,
          inactiveIconColor: AppTheme.white,
          initialSelection: currentPosition,
          tabs: [
            TabData(iconData: Icons.add_a_photo, title: "Camera Scan"),
            TabData(iconData: Icons.filter, title: "Image to Text"),
            TabData(iconData: Icons.picture_as_pdf, title: "File to Text"),
            TabData(iconData: Icons.library_books, title: "History")
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPosition = position;
            });
            switch (position) {
              case 0:
                _snapePicture();
                break;
              case 1:
                _pickImage();
                break;
              case 2:
                _pickFile();
                break;
              case 3:
                _refreshHistory();
               

            }
          },
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: UserAccountsDrawerHeader(
                  accountName: Text('Image to Text'),
                  accountEmail: Text('v0.0.1'),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: AppTheme.white,
                      child: Icon(
                        Icons.person_pin,
                        color: AppTheme.background,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(color: AppTheme.background),
                ),
              ),
              InkWell(
                  onTap: () {
                     Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text('Home'),
                    leading: Icon(Icons.home),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutScreen()));
                  },
                  child: ListTile(
                    title: Text('About'),
                    leading: Icon(Icons.help),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FeedbackScreen()));
                  },
                  child: ListTile(
                    title: Text('Feedback'),
                    leading: Icon(Icons.message),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InviteFriend()));
                  },
                  child: ListTile(
                    title: Text('Invite Friend'),
                    leading: Icon(Icons.share),
                  )),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReateAppScreen()));
                  },
                  child: ListTile(
                    title: Text('Reate App'),
                    leading: Icon(Icons.star),
                  )),
            ],
          ),
        ),
        body: Container(
            width: double.infinity,
            color: AppTheme.nearlyWhite,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  color: AppTheme.nearlyBlack,
                  height: (MediaQuery.of(context).size.height / 2 - 150),
                  child: GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child:
                          ObjectPreview(file: inputFile, fileTitle: fileTitle)),
                ),
                Divider(
                  height: 0,
                ),
                currentPosition == 3
                    ? Container(
                        width: double.infinity,
                        height: (MediaQuery.of(context).size.height / 2),
                        child:
                            HistoryPreview(list: history, inputFile: inputFile))
                    : Container(
                        height: (MediaQuery.of(context).size.height / 2),
                        child: TextPreview(textResult: textResult),
                      )
              ],
            )),
        floatingActionButton: scanningStatus == 1 && currentPosition != 3
            ? Container(
                margin: EdgeInsets.only(bottom: 50),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(
                        width: 70,
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: AppTheme.background,
                          onPressed: () {
                            ResultManager(context, inputFile)
                                .copyText(textResult);
                          },
                          child: Icon(Icons.content_copy),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 70,
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: AppTheme.background,
                          onPressed: () {
                            ResultManager(context, inputFile)
                                .shareText(textResult);
                          },
                          child: Icon(Icons.exit_to_app),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 70,
                        height: 50,
                        child: FloatingActionButton(
                          backgroundColor: AppTheme.background,
                          onPressed: () {
                            ResultManager(context, inputFile)
                                .saveText(textResult);
                          },
                          child: Icon(Icons.save_alt),
                        ),
                      ),
                    ]),
              )
            : Container(
                width: 70,
                height: 50,
                margin: EdgeInsets.only(bottom: 50),
                child: FloatingActionButton(
                  backgroundColor: AppTheme.background,
                  onPressed: () {
                    _snapePicture();
                  },
                  child: Icon(Icons.add_a_photo),
                ),
              ));
  }

  Future<Null> _pickImage() async {
    _resetScreen();
    inputFile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'gif', 'jpeg'],
    );
    if (inputFile != null) {
      setState(() {
        state = AppState.picked;
        _cropImage();
      });
    }
  }

  Future<Null> _pickFile() async {
    _resetScreen();
    inputFile = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc'],
    );
    if (inputFile != null) {
      setState(() {
        state = AppState.cropped;
        _scanObject(inputFile);
      });
    }
  }

  Future<Null> _snapePicture() async {
    _resetScreen();
    inputFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (inputFile != null) {
      setState(() {
        state = AppState.cropped;
        _scanObject(inputFile);
      });
    }
  }

  void _resetScreen() {
    setState(() {
      textResult = "No Conversion Yet";
      inputFile = null;
      scanningStatus = 0;
      currentPosition = 3;
    });
  }

  void _scanObject(File file) async {
    Scanner scanner = Scanner(context: context);
    HistoryManager history = HistoryManager();
    String path = inputFile.path;
    String filename =
        path.substring(path.lastIndexOf("/") + 1, path.lastIndexOf(".")) +
            ".txt";
    dynamic result = await scanner.scan(file);
    setState(() {
      if (result['status'] != "1") {
        scanningStatus = 0;
        textResult = "Unable to extract text from the given Image!";
      } else {
        scanningStatus = 1;
        textResult = result['data'];
        history.add(filename +
            "~|" +
            textResult +
            "~|" +
            DateTime.now().toString() +
            "~|");
         _refreshHistory();
      }
      currentPosition = 1;
    });

  }

  _addTest(){
     HistoryManager history = HistoryManager();
     history.add("image_cropper_1586891598072.txt~|3. Alhaji Musa Yahya C08033041148~|2020-04-14 20:13:36.023289~|");
  }

  void _refreshHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String historyDump = prefs.getString("history");
    if (historyDump != null && historyDump != "[]") {
      historyDump = historyDump.replaceAll("[", "").replaceAll("]", "");
      setState(() {
        history.clear();
        history.addAll(historyDump.split("~|,"));
      });
    } else {
      historyDump = "";
    }
  }

  Future<Null> _cropImage() async {
    print(inputFile);
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: inputFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop where to Scan',
            toolbarColor: AppTheme.background,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop where to Scan',
        ));
    if (croppedFile != null) {
      setState(() {
        inputFile = croppedFile;
        state = AppState.cropped;
      });
      _scanObject(inputFile);
    }
  }
}
