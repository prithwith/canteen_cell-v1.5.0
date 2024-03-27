// ignore_for_file: prefer_const_constructors, must_be_immutable, no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdatePage extends StatefulWidget {
  int versionno;
  String versioncode, appurl, changelog;
  AppUpdatePage(this.versionno, this.versioncode, this.appurl, this.changelog,
      {super.key});

  @override
  State<AppUpdatePage> createState() =>
      _AppUpdatePageState(versionno, versioncode, appurl, changelog);
}

class _AppUpdatePageState extends State<AppUpdatePage> {
  int versionno;
  String versioncode, appurl, changelog;
  _AppUpdatePageState(
      this.versionno, this.versioncode, this.appurl, this.changelog);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 15,
                      left: 8.0,
                      right: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      "New Vesion: $versioncode found",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Text("Please Update your App to Continue"),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      left: 25.0,
                      right: 8.0,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Update the App by Clicking this Button",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      left: 25.0,
                      right: 8.0,
                    ),
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () => launchUrl(
                        Uri.parse(appurl),
                        mode: LaunchMode.externalApplication,
                      ),
                      onLongPress: () {
                        Clipboard.setData(
                          ClipboardData(
                            text: appurl,
                          ),
                        );
                        Fluttertoast.showToast(
                          msg: "Link Copied",
                        );
                      },
                      child: Text("Update"),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 15,
                      left: 30,
                      right: 8.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Change Logs:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      left: 35.0,
                      right: 8.0,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      changelog,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
