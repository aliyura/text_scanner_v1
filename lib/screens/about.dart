import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tscanner/components/themes.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text('About', style: TextStyle(color: AppTheme.white)),
      ),
      body: Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: Column(
              children: <Widget>[
          
                Card(
                    child: Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 16,left:20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('App',style: TextStyle(
                        fontSize:20,
                          fontWeight: FontWeight.bold
                      ),),
                      Divider(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Corona Tracker is a free mobile app that helps in getting world-wide data on Coronavirus spread. It uses publicly available and reliable data sources to show information on COVID-19 cases worldwide. See the numbers or visualize via charts and map clusters.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),

        SizedBox(height: 20,),
                       Text('Developer',style: TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.bold
                      ),),
                      Divider(),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Text(
                          'Made by Rabiu Aliyu\n\nCopyright©2020 Nigeria. All Rights Reserved',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.6),
                                offset: const Offset(4, 4),
                                blurRadius: 8.0),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              _launchURL(
                                  "https://play.google.com/store/apps/details?id=com.rabsdeveloper.coronatracker");
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.thumb_up,color: AppTheme.nearlyWhite,),
                                    SizedBox(width: 10,),
                                    Text(
                                    'Rate App',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                ),
                                
                                ],)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
