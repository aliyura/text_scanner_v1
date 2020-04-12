import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:toast/toast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tscanner/components/object_preview.dart';
import 'package:tscanner/components/text_preview.dart';
import 'package:tscanner/components/themes.dart';
import 'package:tscanner/screens/about.dart';
import 'package:tscanner/screens/feedback.dart';
import 'package:tscanner/screens/invite_friend.dart';
import 'package:tscanner/screens/rate_app.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Scanner',
      theme: ThemeData.light().copyWith(primaryColor: AppTheme.background),
      home: MyApp(),
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
  File imageFile;
  String fileTitle;
  String textResult;
  int currentPosition = 1;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    fileTitle = "Take file to Scan";
    textResult = "No Taxt Scanned Yet";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Text Scanner"),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.comment,
                  color: AppTheme.white,
                ),
                label: Text(
                  'Feedback',
                  style: TextStyle(fontSize: 18, color: AppTheme.white),
                ))
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: UserAccountsDrawerHeader(
                  accountName: Text('Text Scanner v0.0.1'),
                  accountEmail: Text('info@textscanner.com'),
                  currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                      backgroundColor: AppTheme.nearlyBlack.withOpacity(0.5),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
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
        bottomNavigationBar: FancyBottomNavigation(
          initialSelection: 1,
          tabs: [
            TabData(iconData: Icons.picture_as_pdf, title: "Scan PDF"),
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.image, title: "Scan Image")
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPosition = position;
            });
          },
        ),
        body: Container(
            width: double.infinity,
            color: AppTheme.nearlyWhite,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                Container(
                  color: AppTheme.nearlyBlack,
                  height: MediaQuery.of(context).size.height / 3,
                  child:
                      ObjectPreview(imageFile: imageFile, fileTitle: fileTitle),
                ),
                Divider(
                  height: 0,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2.2,
                  child: TextPreview(textResult: textResult),
                )
              ],
            )),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppTheme.background,
          onPressed: () {
            if (state == AppState.free)
              _snapePicture();
            else if (state == AppState.picked)
              _cropImage();
            else if (state == AppState.cropped)
             _saveText();
          },
          child: _buildButtonIcon(),
        ));
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add_a_photo);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.save_alt);
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
        _cropImage();
      });
    }
  }

  Future<Null> _snapePicture() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
        _cropImage();
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
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
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  void _saveText() async {
    Toast.show("Saved", context);
  }
}
